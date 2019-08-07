---
layout: post
title:  "python scrapy 爬虫"
date:   2019-07-05 80:20:18 +0800
categories: python
tags: python scrapy 爬虫 
---

* content
{:toc}





# scrapy 命令行调试

```sh
$ scrapy startproject xxxx				创建一个 xxxx 工程
$ scrapy crawl xxxx -o quotes.json   	抓取爬虫 xxxx 数据，并且输出到 quotes.json 文件中

在终端，输入命令：

scrapy shell https://docs.scrapy.org/en/latest/_static/selectors-sample1.html


输入函数：
>>>  response.xpath('//title/text()').get() 		// 得到标题
>>>  response.xpath('//title/text()').getall()		// 返回一个数组
>>> 
>>>  response.xpath('//body/div/a/img/@src').get() 	// 得到 img 标签下的 src 属性
>>>  response.xpath('//body/div/a/img/@src').getall()
>>> 
>>>  response.xpath('//body/div/a/text()').get()     // 得到 a 标签下的 text() 内容
>>>  response.xpath('//body/div/a/text()').getall()
>>> 
>>>  response.xpath('//body/div/a/@href').get()		// 得到 a  标签下的 herf 属性
>>>  response.xpath('//body/div/a/@href').getall()
>>> 
>>> 
>>> response.xpath('//base/@href').get()			// 返回网站域名
>>> response.css('base::attr(href)').get()			// 返回网站域名
>>> 
>>> 
>>>  response
>>>  response.url
>>> 			

```

## scrapy 代码参考

```python


*******************************************************
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes"

    def start_requests(self):
        urls = [
            'http://quotes.toscrape.com/page/1/',
            'http://quotes.toscrape.com/page/2/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        page = response.url.split("/")[-2]
        filename = 'quotes-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)


*******************************************************
 


import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes"
    start_urls = [
        'http://quotes.toscrape.com/page/1/',
    ]

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'text': quote.css('span.text::text').get(),
                'author': quote.css('small.author::text').get(),
                'tags': quote.css('div.tags a.tag::text').getall(),
            }

        next_page = response.css('li.next a::attr(href)').get()
        if next_page is not None:
            next_page = response.urljoin(next_page)					 # 解析成绝对路径
            yield scrapy.Request(next_page, callback=self.parse)     # 解析下一页数据




*******************************************************


import scrapy

class QuotesSpider(scrapy.Spider):
    name = "quotes"
    start_urls = [
        'http://quotes.toscrape.com/page/1/',
    ]

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'text': quote.css('span.text::text').get(),
                'author': quote.css('span small::text').get(),
                'tags': quote.css('div.tags a.tag::text').getall(),
            }

        next_page = response.css('li.next a::attr(href)').get()
        if next_page is not None:
        
        	 # response.follow supports relative URLs  支持相对路径
            yield response.follow(next_page, callback=self.parse)   



*******************************************************
https://docs.scrapy.org/en/latest/topics/item-pipeline.html

Write items to MongoDB
In this example we’ll write items to MongoDB using pymongo. MongoDB address and database name are specified in Scrapy settings; MongoDB collection is named after item class.

The main point of this example is to show how to use from_crawler() method and how to clean up the resources properly.:


import pymongo

class MongoPipeline(object):

    collection_name = 'scrapy_items'

    def __init__(self, mongo_uri, mongo_db):
        self.mongo_uri = mongo_uri
        self.mongo_db = mongo_db

    @classmethod
    def from_crawler(cls, crawler):
        return cls(
            mongo_uri=crawler.settings.get('MONGO_URI'),
            mongo_db=crawler.settings.get('MONGO_DATABASE', 'items')
        )

    def open_spider(self, spider):
        self.client = pymongo.MongoClient(self.mongo_uri)
        self.db = self.client[self.mongo_db]

    def close_spider(self, spider):
        self.client.close()

    def process_item(self, item, spider):
        self.db[self.collection_name].insert_one(dict(item))
        return item

```






## www.23us.so 小说爬取

```python

# -*- coding: utf-8 -*-
import scrapy
import os
from time import gmtime, strftime

#
#   www.23us.so 小说资源解析
#
class Book23Us(scrapy.Spider):

    name = 'book_23us'

    # 保留，在 start_requests 函数中进行初始化
    # start_urls = [
    #     # 'https://www.23us.so/files/article/html/0/43/index.html',
    #     'https://www.23us.so/files/article/html/13/13694/index.html',
    # ]

    # 当前书籍的名字 (存储本地)
    # book_path = os.getcwd()+'/out/'
    book_path = '/Volumes/wuliqiang/QQSpider/book_www.23us.so/'
    
    # 初始化请求路径
    def start_requests(self):
        urls = [
            # 'https://www.23us.so/files/article/html/13/13694/index.html',
        ]

        # for i in range(1, 4999):
        for i in range(1, 4999):
            urls.append('https://www.23us.so/files/article/html/0/%d/index.html'%(i))

        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    # 解析章节列表
    def parse(self, response):

        # 题目编号索引
        book_num_start = 10001

        # 时间标记 
        # time_tag = strftime("%Y%m%d-%H%M%S", gmtime())
        time_tag = ''

        # 分类
        book_type = response.xpath('//*[@id="a_main"]/div[2]/dl/dt/a[2]/text()').get()
        book_name = response.xpath('//*[@id="a_main"]/div[2]/dl/dt/a[3]/text()').get()

        # 存储目录
        book_dir = self.book_path+book_type+'/'+book_name

        # 章节列表
        titles = response.xpath('//*[@id="at"]').xpath('//table/tr/td/a/text()').getall()
        urls = response.xpath('//*[@id="at"]').xpath('//table/tr/td/a/@href').getall()

        # 生成 json 文件配置
        # index = 0
        # for title in titles:
        #     yield{
        #         'title': title,
        #         'url': urls[index]
        #     }
        #     index += 1


        # 创建目录
        if not os.path.exists(book_dir):
            os.makedirs(book_dir)

        file_path_name = book_dir+'/'+str(book_num_start)+'-'+book_name + '_目录_.txt'
        
        if not os.path.exists(file_path_name):
            # 有新的图书出现，可以发送邮件通知一下
            pass

        # 将抓取内容写入到文件中
        file = open(file_path_name,'w')
        file.writelines(book_type+"----"+book_name)
        file.writelines('\n')

        for title in titles:
            file.writelines('\n')
            file.writelines(title)

        file.close()

        # 透传参数
        req_data = {
            'book_type' : book_type,
            'book_name' : book_name,
            'book_dir' : book_dir,
            'time_tag' : time_tag,
            'book_num': book_num_start           # 标题编号，每次加1
        }

        # 解析每一个章节的详细数据
        for url in urls:
            req_data['book_num'] += 1
            yield scrapy.Request(url, callback=self.parse_article_info, meta=req_data)

    
    # 解析章节详细信息
    def parse_article_info(self, response):

        book_name = response.meta['book_name']
        book_dir = response.meta['book_dir']
        book_type = response.meta['book_type']
        book_num = response.meta['book_num']

        title = response.xpath('//*[@id="amain"]/dl/dd[1]/h1/text()').get()
        contents = response.xpath('//*[@id="contents"]/text()').getall()


        # # 创建分类目录
        # if not os.path.exists(book_type):
        #     os.mkdir(book_type)

        # 创建目录
        if not os.path.exists(book_dir):
            os.makedirs(book_dir)

        
        file_path_name = book_dir+'/'+str(book_num)+'-'+book_name +'-'+ title +'.txt'
        
        if not os.path.exists(file_path_name):
            # 有章节更新，这里可以发送一个邮件通知一下用户
            pass

        # 写入到文件中
        file = open(file_path_name,'w')
        file.writelines(title)
        file.writelines('\n')

        for content in contents:
            file.writelines(content)

        file.close()



```

## huanyue123 小说爬取

```python

# -*- coding: utf-8 -*-
import scrapy
import os
import logging
from time import gmtime, strftime
from ..base import BaseUtil
from ..items import *

#
#   http://www.huanyue123.com 小说资源解析
#
class BookHuanYue(scrapy.Spider):

    name = 'book_huanyue'

    allowed_domains = ['huanyue123.com']

    # 下载文件存储路径 (从缓存中导出后存放路径)
    # sav_path = os.getcwd()+'/out/'
    # sav_path = '/Volumes/wuliqiang/QQSpider/book_mysql/'

    # 相对路径，项目目录下面/download 文件夹
    sav_path = 'download/book_mysql/'
    
    # 初始化请求路径
    def start_requests(self):

        urls = [
            # 'http://www.huanyue123.com/book/0/1/',
        ]

        # for i in range(1, 55000):
        # for i in range(1, 100):
        # for i in range(500, 600):
        # for i in range(600, 700):
        # for i in range(700, 800):
        # for i in range(800, 900):
        # for i in range(900, 1000):
        # for i in range(1000, 1100):
        for i in range(1, 55000):
            urls.append('http://www.huanyue123.com/book/0/%d/'%(i))

        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    # 解析章节列表
    def parse(self, response):

        log = logging.getLogger('qqlog')

        # 时间标记 
        # time_tag = strftime("%Y%m%d-%H%M%S", gmtime())
        time_tag = ''

        # 书籍信息
        book_type = response.xpath('//div[@class="title"]/b/a[2]/text()').get()
        book_name = response.xpath('//div[@class="book_info"]//div[@id="info"]/h1/text()').get()
        book_author = response.xpath('//div[@class="book_info"]//div[@class="options"]/span/text()').get()[3:]
        book_status = response.xpath('//div[@class="book_info"]//div[@class="options"]/span[2]/text()').get()
        book_cover_url = response.xpath('//div[@class="book_info"]//div[@class="pic"]/img/@src').get()

        # 描述信息
        book_desc = response.xpath('//h3[@class="bookinfo_intro"]/text()').getall()
        book_desc_str = ''.join(book_desc)

        # 最后一次更新时间
        book_uptime = response.xpath('//span[@class="hottext"]/text()').get()[5:]

        # 书籍章节列表
        ch_names = response.xpath('//div[@class="book_list"]/ul/li/a/text()').getall()
        ch_urls = response.xpath('//div[@class="book_list"]/ul/li/a/@href').getall()

        # log.info('%s,%s,%s,%s', book_type, book_name, book_author, book_status)

        itemBook = Book()

        # 使用 md5 加密算法作为书籍的唯一 uid (防止同一本书籍多次添加)
        itemBook['id'] = BaseUtil.GetMD5(str(book_name+'-'+book_author).encode('utf-8'))
        itemBook['name'] = book_name
        itemBook['author'] = book_author
        itemBook['type'] = book_type
        itemBook['status'] = book_status
        itemBook['corver'] = book_type + '/' + book_name +os.path.splitext(book_cover_url)[-1]
        itemBook['desc'] = book_desc_str
        itemBook['net_url'] = response.url
        itemBook['hot_num'] = '0'
        itemBook['n_ch_name'] = ch_names[-1]
        itemBook['n_ch_id'] = BaseUtil.GetMD5(str(book_name+'-'+book_author+'-'+ch_names[-1]).encode('utf-8'))
        itemBook['n_ch_uptime'] = book_uptime
        itemBook['date_str'] = BaseUtil.GetDateStr()
        itemBook['date_num'] = BaseUtil.GetDateNum()
        itemBook['beizhu'] = ''
        yield itemBook

        # 相关的下载资源
        itemFile = FileItem()
        itemFile['file_sav_path'] = self.sav_path  
        itemFile['file_urls'] = [book_cover_url]
        itemFile['file_names'] = [book_name]
        itemFile['file_types'] = [book_type]
        yield itemFile
        

        # 透传参数
        req_data = {
            'book_id' : itemBook['id'],
            'book_name' : book_author,
            'book_author' : book_name,
            'index': 10000           # 编号，每次加1
        }

        # 请求每一个章节数据
        for i in range(len(ch_urls)):
            # log.info('%s, %s', ch_names[i], ch_urls[i])
            req_data['index'] += 1
            yield scrapy.Request(url=ch_urls[i], callback=self.prase_chapter,meta=req_data)


    # 解析章节信息
    def prase_chapter(self, response):

        ch_name = response.xpath('//div[@class="h1title"]/h1/text()').get()
        ch_content = response.xpath('//div[@id="htmlContent"]/text()').getall()
        # 转换成字符串
        ch_content_str = ''.join(ch_content)

        itemChapter = BookChapter()

        itemChapter['id'] = BaseUtil.GetMD5(str(response.meta['book_name']+'-'+response.meta['book_author']+'-'+ch_name).encode('utf-8'))
        itemChapter['name'] = ch_name
        itemChapter['content'] = ch_content_str
        itemChapter['book_id'] = response.meta['book_id']
        itemChapter['index'] = str(response.meta['index'])
 
        yield itemChapter

        pass

```