#/bin/bash

num=1
ababa=1
count=0
for data in `cat channel_list.cfg`
do
    if [ $(($num%2)) != 0 ]
    then 
    chNameCN[${num}]=${data}
    else
    chname[${num-1}]=${data}
    while (( $count<$1 ))
    do
        thedate=`date  +"%Y-%m-%d" -d  "-${count} days"`
        if [ $2=="m" ]
        then
            scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num-1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num-1]} ${thedate}.epg.${chname[num]}" &> /dev/null
        else
            scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num-1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num-1]} ${thedate}.json" &> /dev/null
        fi
        let count++
    done
    fi
    let num++
    count=0
done
if [ $2=="m" ]
then
 bash ./mergeAllEPG.sh &> /dev/null
fi