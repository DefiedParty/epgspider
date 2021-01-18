import scrapy
import json

chName = "fhzw"
jsonList = {"fhzw":[]}
programInfoList = {"start":0,"stop":0,"title":""}

class epgSpider(scrapy.Spider):
    name = "epgjson"

    def start_requests(self):
        urls = [
            'http://epg.51zmt.top:8000/api/i/?ch=%E5%87%A4%E5%87%B0%E4%B8%AD%E6%96%87&date=2021-01-15',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        list =response.css('li')
        for program in list:
            print("111111")            
            programInfoList["start"]=program.css('td::text')[0].extract()
            programInfoList["title"]=program.css('td::text')[1].extract()
            jsonList["fhzw"].append(programInfoList)
            print("22")
        output=json.dumps(jsonList)
        #page = response.url.split("/")[-2]
        filename = f'fullepg.json'
        with open(filename, 'w') as f:
            f.write(output)
        self.log(f'Saved file {filename}')