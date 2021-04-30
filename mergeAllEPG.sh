if [ ! -d "epg_files/" ]; then
    mkdir epg_files
fi
if [ ! -d "json_files/" ]; then
    mkdir json_files
fi
if [ ! -d epg_db/*.epg.* ]; then
    echo 没有找到节目单~
    exit
fi
cp epg_db/*.epg.* epg_files/
if [ ! -d fullepgs.json ]; then
    touch fullepgs.json
fi
for keys in `jq -r 'keys|.[]' epg_files/*.epg.*`
do
    jq  -a ".${keys}|.[]" epg_files/*.${keys} | jq -a -s 'reduce . as $item ([]; . +$item)' | jq -a "{"${keys}":.}" &> json_files/${keys}.json
done
rm -rf epg_files/*
jq -a -s 'reduce .[] as $item ({}; .+$item)' json_files/*.json &> fullepgs.json
rm -rf json_files/*