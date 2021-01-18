import scrapy
import json
import copy

chName = "fhzw"
chNameCN = "凤凰中文"
targetDate="2021-01-15"
jsonList = {chName: []} 
programInfoList = {"start": 0, "stop": 0, "title": ""}


class epgSpider(scrapy.Spider):
    name = "epgjson"

    def start_requests(self):
        global chNameCN
        global targetDate
        chNameCN = getattr(self, chNameCN, False)
        targetDate = getattr(self, targetDate, False)
        urls = [
            'http://epg.51zmt.top:8000/api/i/?ch=%s&date=%s'%(chNameCN,targetDate),
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        list = response.css('li')
        print(chNameCN)
        for program in list:
            programInfoList["start"] = program.css('td::text')[0].extract()
            programInfoList["title"] = program.css('td::text')[1].extract()
            jsonList["fhzw"].append(copy.copy(programInfoList))
        output = json.dumps(jsonList)
        #page = response.url.split("/")[-2]
        filename = f'fullepg.json'
        with open(filename, 'w') as f:
            f.write(output)
        self.log(f'Saved file {filename}')
