import scrapy
import json
import copy
import time

chName = ""
jsonList = {chName: []}
programInfoList = {"start": 0, "stop": 0, "title": ""}
theDate = "2021-01-13"
filename = f'fullepg.json'
# 定义一些全局变量方便使用


class epgSpider(scrapy.Spider):
    name = "epgjson"

    def __init__(self, chname=None, chNameCN=None, targetDate=None, fileName=f'fullepg.json', *args, **kwargs):  # 传入参数
        super(epgSpider, self).__init__(*args, **kwargs)
        global chName
        global jsonList
        global theDate
        global filename
        chName = chname
        jsonList = {chName: []}
        theDate = targetDate
        filename = f'%s' % (fileName)
        self.start_urls = [
            'http://epg.51zmt.top:8000/api/i/?ch=%s&date=%s' % (
                chNameCN, targetDate)
        ]

    def start_requests(self):
        for url in self.start_urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        list = response.css('li')  # 存储<li>标签
        for program in list:
            # 直接转换时间戳
            timeArray = time.strptime(
                theDate+' '+program.css('td::text')[0].extract(), "%Y-%m-%d %H:%M")
            timestamp = time.mktime(timeArray)
            programInfoList["start"] = int(timestamp)  # 整形存入
            programInfoList["title"] = program.css('td::text')[1].extract()
            jsonList[chName].append(copy.copy(programInfoList))  # 添加各节目字典
        # 遍历确定结束时间
        for num, item in enumerate(jsonList[chName]):
            if num == 0:
                print(233)
            else:
                jsonList[chName][num-1]["stop"] = jsonList[chName][num]["start"]
        # 特殊处理最后一组节目
        endTimeArray = time.strptime(
            theDate+' '+'23:59:59', "%Y-%m-%d %H:%M:%S")
        endTimeStamp = time.mktime(endTimeArray)
        jsonList[chName][-1]["stop"] = int(endTimeStamp)
        output = json.dumps(jsonList)  # 字典降级
        output = output.replace("&nbsp&nbsp&nbsp", "")  # 移除多余的html字段
        #filename = f'fullepg.json'
        with open(filename, 'w') as f:
            f.write(output)
        self.log(f'Saved file {filename}')
