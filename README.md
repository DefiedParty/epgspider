# 电视节目清单爬虫

## 使用
- 安装Scrapy

    `pip install Scrapy`

- 安装 jq
    
    `sudo apt-get install jq`

    详见 [Download jq](https://stedolan.github.io/jq/download/)

- 克隆项目到本地

    `git clone https://github.com/DefiedParty/epgspider`

- 给👴爬

    `scrapy crawl epgjson -a chname=jxtv -a chNameCN=江西卫视 -a targetDate=2021-01-19 -a fileName=啊吧啊吧.json`

---

## 扩展脚本

`bash ./epg_get.sh n1 n2 m c`

`n1` 指定了爬取向前推多少天内的节目单，使用负数或 `0` 表示

`n2` 指定了爬取向前推多少天内的节目单，使用正数或 `0` 表示

`m` 指定是否需要合并

`c` 指定是否需要清理 `epg_db` 文件夹

**下面是一个例子：**

这是项目目录下的 `channel_list.cfg` ：
    
    CCTV1 cctv1
    河南卫视 hatv
    陕西卫视 sntv
    江西卫视 jxtv

当前系统时间：2021-05-28

执行 `bash ./epg_get.sh -1 0` 将在项目目录下生成下列文件：

    河南卫视 2021-05-27.json
    河南卫视 2021-05-28.json
    江西卫视 2021-05-27.json
    江西卫视 2021-05-28.json
    陕西卫视 2021-05-27.json
    陕西卫视 2021-05-28.json
    CCTV1 2021-05-27.json
    CCTV1 2021-05-28.json

如果添加参数 `m`

`bash ./epg_get.sh -1 0 m`

那么在项目目录下仅生成一个合并后的 `fullepgs.json`

*提示：* 
- 如果使用合并参数 `m` ，那么将在目录 `epg_db/` 下存储曾经爬取的所有节目单，且不会自动删除。此举为了节约重复爬取时消耗的服务器资源！

- 使用合并参数 `m`的情况下，为了防止 `部分频道不提供预告，从而导致所有日期的节目单内容都只为一条 “0：00 暂未提供节目表”` 的情况出现，现在将强制爬取时对应系统日期的节目单。

- 已经提供了清理 `epg_db` 目录的选项，再使用合并功能（使用合并参数 `m` ）的情况下，在其后加上参数 `c` 即可删除时间段外的所有节目单缓存。

---

## 说明

- `chname` 指定了键，可随意设置

- `chNameCN` 意为“频道名”，用于请求数据，有确定性

- `targetDate` 意为“请求清单日期”，用于请求数据

**注意！**  `fileName` 为非必选项！

运行结束后会在项目根目录生成 `fullepg.json` ,格式如下：

    {
        "jxtv": [
            {
                "start": 1610994900,
                "stop": 1611000300,
                "title": "\u7eaa\u5f55\u7247"
            },
            {
                "start": 1611000300,
                "stop": 1611009600,
                "title": "\u6df1\u591c\u5267\u573a"
            },
            {
                "start": 1611009600,
                "stop": 1611010800,
                "title": "\u6c5f\u897f\u65b0\u95fb\u8054\u64ad"
            },
            .......
            {
                "start": 1611069900,
                "stop": 1611071999,
                "title": "\u7cbe\u54c1\u5267\u573a"
            }
        ]
    }
