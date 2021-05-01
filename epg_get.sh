#/bin/bash

num=1
count=$1
for data in $(cat channel_list.cfg); do
    if [ $(($num % 2)) != 0 ]; then
        chNameCN[${num}]=${data}
    else
        chname[${num-1}]=${data}
        while [ $count -le $2 ]; do
            thedate=$(date +"%Y-%m-%d" -d "${count} days")
            if [ "$3" == "m" ]; then
                if [ ! -f "epg_db/${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" ]; then
                    scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num - 1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" &>/dev/null
                    if [ ! -d "epg_db/" ]; then
                        mkdir epg_db
                    fi
                    mv *.epg.* epg_db/
                fi
            else
                scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num - 1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num - 1]} ${thedate}.json" &>/dev/null
            fi
            let count++
        done
    fi
    let num++
    count=$1
done
if [ "$3" == "m" ]; then
    bash ./mergeAllEPG.sh $1 $2 #&>/dev/null
fi
