#/bin/bash

num=1
count=$1
rm -rf buff/
mkdir buff
#循环读取配置文件信息
for data in $(cat channel_list.cfg); do
    #判断单双分别存取频道名及简写
    if [ $(($num % 2)) != 0 ]; then
        chNameCN[${num}]=${data}
    else
        chname[${num-1}]=${data}
        #获取到简写即为一组数据，即可开始操作。从最早的一天开始循环，一直到最晚的一天
        while [ $count -le $2 ]; do
            #取得目标日标准日期
            thedate=$(date +"%Y-%m-%d" -d "${count} days")
            cp epg_db/"${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" buff/
            let count++
        done
    fi
    let num++
    count=$1
done
if [[ -n buff/* ]]; then
    rm -rf epg_db/*
    cp buff/* epg_db/
    rm -rf buff
fi
