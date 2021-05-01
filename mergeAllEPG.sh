if [ ! -d "epg_files/" ]; then
    mkdir epg_files
fi
if [ ! -d "json_files/" ]; then
    mkdir json_files
fi
if [[ ! -n epg_db/*.epg.* ]]; then
    echo 没有找到节目单~
    exit
fi
num=1
count=$1
for data in $(cat channel_list.cfg); do
    if [ $(($num % 2)) != 0 ]; then
        chNameCN[${num}]=${data}
    else
        chname[${num-1}]=${data}
        while [ $count -le $2 ]; do
            thedate=$(date +"%Y-%m-%d" -d "${count} days")
            cp "epg_db/${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" epg_files/
            let count++
        done
    fi
    let num++
    count=$1
done
#cp epg_db/*.epg.* epg_files/
if [ ! -d fullepgs.json ]; then
    touch fullepgs.json
fi
for keys in $(jq -r 'keys|.[]' epg_files/*.epg.*); do
    jq -a ".${keys}|.[]" epg_files/*.${keys} | jq -a -s 'reduce . as $item ([]; . +$item)' | jq -a "{"${keys}":.}" &>json_files/${keys}.json
done
rm -rf epg_files/*
jq -a -s 'reduce .[] as $item ({}; .+$item)' json_files/*.json &>fullepgs.json
rm -rf json_files/*
echo "本次合并了从 $(date +"%Y-%m-%d" -d "$1 days") 至 $(date +"%Y-%m-%d" -d "$2 days") 总共 $(((${num} - 1) / 2)) 个频道的节目单，已经存到项目根目录下的 fullepgs.json "
