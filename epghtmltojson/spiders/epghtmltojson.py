import scrapy
import json
import copy

chName = "fhzw"
jsonList = {chName: []} 
programInfoList = {"start": 0, "stop": 0, "title": ""}


class epgSpider(scrapy.Spider):
    name = "epgjson"

    def __init__(self, chNameCN=None,targetDate=None, *args, **kwargs):
        super(epgSpider, self).__init__(*args, **kwargs)
        self.start_urls=[
            'http://epg.51zmt.top:8000/api/i/?ch=%s&date=%s'%(chNameCN,targetDate)
        ]

    def start_requests(self):
        for url in self.start_urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        list = response.css('li')
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
