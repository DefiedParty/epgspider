#/bin/bash

#循环读取文件计数器
num=1
#循环计算日期计数器
count=$1
#循环读取配置文件信息
for data in $(cat channel_list.cfg); do
    #判断单双分别存取频道名及简写
    if [ $(($num % 2)) != 0 ]; then
        chNameCN[${num}]=${data}
    else
        chname[${num-1}]=${data}
        #获取到简写即为一组数据，即可开始爬取。从最早的一天开始循环，一直到最晚的一天
        while [ $count -le $2 ]; do
            #取得目标日标准日期
            thedate=$(date +"%Y-%m-%d" -d "${count} days")
            #是否需要合并
            if [ "$3" == "m" ]; then
                #判断是否存在，存在跳过不爬，不存在才爬取，节约服务器资源
                if [ ! -f "epg_db/${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" ]; then
                    scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num - 1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" &>/dev/null
                    #检测是否有数据库文件夹，并处理
                    if [ ! -d "epg_db/" ]; then
                        mkdir epg_db
                    fi
                    #移动至数据库文件夹
                    mv *.epg.* epg_db/
                fi
                #强行获取今日清单
                if [ $count -eq 0 ]; then
                    scrapy crawl epgjson -a chname="${chname[num]}" -a chNameCN="${chNameCN[num - 1]}" -a targetDate="${thedate}" -a fileName="${chNameCN[num - 1]} ${thedate}.epg.${chname[num]}" &>/dev/null
                    #检测是否有数据库文件夹，并处理
                    if [ ! -d "epg_db/" ]; then
                        mkdir epg_db
                    fi
                    #移动至数据库文件夹
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
#是否与要整合为一个文件，调用整合脚本
if [ "$3" == "m" ]; then
    bash ./mergeAllEPG.sh $1 $2 #&>/dev/null
fi
#需要合并的前提下是否需要清理数据库
if [ "$4" == "c" ]; then
    bash ./dbManager.sh $1 $2 #&>/dev/null
fi
