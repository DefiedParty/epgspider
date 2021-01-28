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
        scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num-1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num-1]} ${thedate}.json"
        
        let count++
        sleep 10s
    done
    fi
    let num++
    count=0
done