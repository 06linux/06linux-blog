---
layout: post
title:  "python mysql 数据库操作简单封装"
date:   2019-08-07 08:10:11 +0800
categories: python
tags: python msyql
---

* content
{:toc}






# 代码如下

```python

# 
# mysql 数据操作简单的封装
# 作者: 06linux
# 
class BaseDB:

   # mysql 链接配置参数
   config_host = '127.0.0.1'
   config_port = 3306
   config_user = 'user111'
   config_passwd = '123456'

   # 数控名字
   config_dbname = 'test_db'  

   # 开发环境 ip 地址
   ip_dev= '192.168.1.201'

   def __init__(self, dbname):

      # 服务器部署环境配置
      if BaseDB.ip_dev != BaseUtil.GetLocalIP():
         BaseDB.config_passwd = '123456'

      # 初始化数据库连接配置
      self.db_conn = pymysql.connect(
                           host = BaseDB.config_host, 
                           port = BaseDB.config_port, 
                           user = BaseDB.config_user, 
                           passwd = BaseDB.config_passwd, 
                           db = dbname
                     )

   # 关闭数据库连接
   def Close(self):
      self.db_conn.close()
      pass                  

   # 提交变动到数据库中             
   def Commit(self):
      self.db_conn.commit()    

   # 
   #  增加一条记录
   #  tableName 表名
   #  dataDict 要添加的数据，必须是 Dictionaries 数据类型， 例如  {'id': '1111', 'name': 'zhangsan'}
   # 
   #  使用示例： 
   #  db.Add('user',{'id':BaseUtil.GetUID(), 'name':'张三风', 'desc':'哈哈。。。'})
   #  db.Commit()
   # 
   def Add(self, tableName, dataDict):

      # 元素的个数
      # dataLen = len(dataDict)

      #  获取 key value 数组
      # dataKeys = data.viewkeys()
      # dataValues = data.viewvalues()

      # 数据库插入 sql 语句格式
      #sql = "INSERT INTO tablename( id,name,desc) VALUES(%s,%s,%s)"

      sql = 'INSERT INTO `' + tableName
      sql += '`('

      index = 0
      for key in dataDict:
         if index > 0:
            sql += ','
         sql += ('`'+key+'`')
         index += 1

      sql += ') VALUES('   

      index = 0
      for key in dataDict:
         if index > 0:
            sql += ','
         sql +=  ('\''+str(dataDict[key])+'\'') 
         index += 1

      sql += ')' 

      # print('sql='+sql)
      cursor = self.db_conn.cursor()
      cursor.execute(sql)
      cursor.close()


   # 查询数据
   # talbeName 表格名字
   # keyList 字段名字， 格式： ['id','name', 'desc]
   # whereDict 查询条件格，格式：{'id':'=1001','name':'=zhangsan'} 或者直接传递字符格式的查询条件
   # orderBy 是排序 设置选项，格式：  'name asc' 或者 'name desc'
   # 
   # 使用示例：
   # db.Get('user',['id','name'],{'id':'1001','name':'zhangsan'})
   # db.Get('user',['id','name','desc'],'name="lisi"')
   # 
   def Get(self, talbeName, keyLists, whereDict, orderBy =''):

      # sql 语句格式
      # SELECT id, name , desc FROM tableName WHERE xxxxx 

      sql = 'SELECT '
      sqlWhere = ''

      index = 0
      for key in keyLists:
         if index > 0:
            sql += ','
         sql += ('`'+str(key)+'`')
         index += 1

      sql += ' FROM '   
      sql += talbeName 

      # 设置查询条件，如果传递的参数是字符串类型，则直接拼接到 where 查询条件中
      if type(whereDict) == str:
         sqlWhere = whereDict
      else:
         sqlWhere = ''
         index = 0
         for key in whereDict:
            if index > 0:
               sqlWhere += ' and '
            sqlWhere += ('`'+key+'`'+'='+'\''+str(whereDict[key])+'\'') 
            index += 1
      
      if len(sqlWhere) > 0:
         sql += (' WHERE ' + sqlWhere ) 

      if len(orderBy) > 0:
         sql += (' ORDER BY ' + orderBy)

      print('sql='+sql)

      cursor = self.db_conn.cursor()
      retCount = cursor.execute(sql)

      # 返回一个list数组
      retLists = []

      for row in cursor:
         # print('row:=',row)

         dictData = {}
         index = 0
         for key in keyLists:
            # print('key=',key)
            dictData[key] = row[index]
            index += 1
         retLists.append(dictData)
         
      cursor.close()
      return retLists

   # 模糊查询函数
   # 使用举例：db.GetGetLike('user',['id','name'],{'name':'zhang'})  模糊查找，名字中包含 zhang 的
   # 
   def GetLike(self, talbeName, keyLists, whereDict, orderBy =''):

      # sql 语句格式
      # SELECT id, name , desc FROM tableName WHERE xxxxx 

      sql = 'SELECT '
      sqlWhere = ''

      index = 0
      for key in keyLists:
         if index > 0:
            sql += ','
         sql += ('`'+str(key)+'`')
         index += 1

      sql += ' FROM '   
      sql += talbeName 

      # 设置查询条件，如果传递的参数是字符串类型，则直接拼接到 where 查询条件中
      if type(whereDict) == str:
         sqlWhere = whereDict
      else:
         sqlWhere = ''
         index = 0
         for key in whereDict:
            if index > 0:
               sqlWhere += ' and '
            sqlWhere += ('`'+key+'`'+' like '+'\'%'+str(whereDict[key])+'%\'') 
            index += 1
      
      if len(sqlWhere) > 0:
         sql += (' WHERE ' + sqlWhere ) 

      if len(orderBy) > 0:
         sql += (' ORDER BY ' + orderBy)

      print('sql='+sql)

      cursor = self.db_conn.cursor()
      retCount = cursor.execute(sql)

      # 返回一个list数组
      retLists = []

      for row in cursor:
         # print('row:=',row)

         dictData = {}
         index = 0
         for key in keyLists:
            # print('key=',key)
            dictData[key] = row[index]
            index += 1
         retLists.append(dictData)
         

      cursor.close()
      return retLists



   # 删除数据
   # talbeName 表格名字
   # whereDict 查询条件格，格式：{'id':'1001','name':'zhangsan'} 或者直接传递字符格式的查询条件
   # 返回： 返回成功删除数据的行数
   # 注意：删除数据操作一定要慎重！！！，建议统一使用 db.Del('user', {'id':'1001'}) 这个格式进行删除
   # 
   # 
   # 使用示例：
   # count = db.Del('user', {'id':'1001'})
   # count = db.Del('user', {'id':'1003','name':'chuyunfei'})
   # count = db.Del('user', {'name':'李云龙'})
   # count = db.Del('user', 'name="楚云飞"')
   # db.Commit()   
   # 
   def Del(self, talbeName, whereDict):

      # sql 语句格式
      # DELETE FROM table_name WHERE some_column=some_value;

      sql = 'DELETE FROM '
      sqlWhere = ''
   
      sql += talbeName 

      # 设置查询条件，如果传递的参数是字符串类型，则直接拼接到 where 查询条件中
      if type(whereDict) == str:
         sqlWhere = whereDict
      else:
         sqlWhere = ''
         index = 0
         for key in whereDict:
            if index > 0:
               sqlWhere += ' and '
            sqlWhere += ('`'+str(key)+'`'+'='+'\''+str(whereDict[key])+'\'') 
            index += 1
      
      if len(sqlWhere) > 0:
         sql += (' WHERE ' + sqlWhere ) 
      else:
         # 防止把整个表格都清空了！
         return 0;      

      print('sql='+sql)
      cursor = self.db_conn.cursor()
      retCount = cursor.execute(sql)
      cursor.close()

      # 返回成功删除数据的行数
      return retCount


   # 更新数据
   # talbeName 表格名字 
   # newDataDict 更新的数据 ，格式：{'id':'1001','name':'zhangsan'}
   # whereDict 查询条件格，格式：{'id':'1001','name':'zhangsan'} 或者直接传递字符格式的查询条件
   # 返回： 返回成功修改数据的行数
   # 注意：数据操作一定要慎重！！！
   # 
   # 
   # 使用示例：db.Update('user',{'name':'杨过杨过','desc':"我是杨过。。我是杨过。。我是杨过。。"}, {'id':'1002'})
   # 
   def Update(self, talbeName, newDataDict, whereDict):

      # sql 语句格式
      # UPDATE table_name SET column1=value1,column2=value2,... WHERE some_column=some_value;

      sql = 'UPDATE '
      sqlWhere = ''
   
      sql += talbeName 
      sql += ' SET '

      index = 0
      for key in newDataDict:
         if index > 0:
            sql += ','
         sql += ('`'+str(key)+'`'+'='+'\''+str(newDataDict[key])+'\'') 
         index += 1

      # 设置查询条件，如果传递的参数是字符串类型，则直接拼接到 where 查询条件中
      if type(whereDict) == str:
         sqlWhere = whereDict
      else:
         sqlWhere = ''
         index = 0
         for key in whereDict:
            if index > 0:
               sqlWhere += ' and '
            sqlWhere += ('`'+str(key)+'`'+'='+'\''+str(whereDict[key])+'\'') 
            index += 1
      
      if len(sqlWhere) > 0:
         sql += (' WHERE ' + sqlWhere ) 
      else:
         # 防止把整个表格都清空了！
         return 0;      

      print('sql='+sql)
      cursor = self.db_conn.cursor()
      retCount = cursor.execute(sql)
      cursor.close()

      # 返回成功删除数据的行数
      return retCount


```


## 功能测试和使用举例

```python

# 测试函数
def test():
   print ("test base.py--")

   # uid = BaseUtil.GetUID()
   # print("uid = %s"%(uid))

   db = BaseDB('qqspider')

   # # 增加数据测试
   db.Add('user',{'id':BaseUtil.GetUID(), 'name':'李云龙', 'desc':'哗啦啦...'})
   db.Add('user',{'id':BaseUtil.GetUID(), 'name':'楚云飞', 'desc':'哗啦啦'})
   db.Add('user',{'id':BaseUtil.GetUID(), 'name':'梅超风', 'desc':'haha'})
   db.Add('user',{'id':BaseUtil.GetUID(), 'name':'黄药师', 'desc':'haha'})
   db.Add('user',{'id':BaseUtil.GetUID(), 'name':'黄蓉', 'desc':'haha'})
   db.Add('user',{'id':BaseUtil.GetUID(), 'name':'江南七怪', 'desc':'haha'})
   db.Commit()

   # 查询数据测试
   print('--------------------')
   userData = db.Get('user',['id','name'],'','id asc')
   print(userData)

   print('--------------------')
   userData = db.Get('user',['id','name'],{'id':'1001'})
   userData = db.Get('user',['id','name'],{'id':'1001','name':'zhangsan'})
   print(userData)

   print('--------------------')
   userData = db.Get('user',['name','desc'],'name="江南七怪"')
   print(userData)

   # 删除数据测试
   print('--------------------')
   count = db.Del('user', {'id':'e7a34675-52ed-11e9-b676-406c8f3b8b21'})
   count = db.Del('user', {'id':'1003','name':'chuyunfei'})
   count = db.Del('user', {'name':'江南七怪'})
   count = db.Del('user', {'desc':'哈哈哈哈哈哈哈哈'})
   count = db.Del('user', 'name="楚云飞"')
   db.Commit()
   print('del count=',count)

   # 更新数据测试
   print('--------------------')
   count = db.Update('user',{'name':'杨过杨过','desc':"我是杨过。。我是杨过。。我是杨过。。"}, {'id':'1002'})
   count = db.Update('user',{'name':'哈哈','desc':"哈哈哈哈哈哈哈哈"}, {'desc':'haha'})
   db.Commit()
   print('update count=',count)


```