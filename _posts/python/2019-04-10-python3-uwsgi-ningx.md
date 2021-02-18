---
layout: post
title:  "centos 7.x 系统，nginx+wusgi+python3+flask+mysql网站开发环境配置"
date:   2019-04-10 15:20:18 +0800
categories: nginx
tags: python nginx flask web mysql
---

* content
{:toc}



# centos 7.x 环境搭建文档

## 常用命令备注

```
目录创建
# mkdir -p {/server,/server/app,/server/install,/server/backup,/server/www};
	
远程登录
# ssh root@192.168.1.100
	
文件拷贝
# scp -r xxx_file1 root@192.168.0.100:~/dirName/
	
安装 gcc (提示没有安装 gcc ，使用此命令安装 gcc)
# yum install gcc  
	
有时候莫名奇妙连不上服务器，把防火墙关掉在试一下。
# service iptables stop 
	
查看端口进程
# netstat -lnp | grep 5000
# netstat -na | grep 3306
# netstat -anlp | grep 10001
# lsof -i:3306
	
查看系统进程
# ps -ef
# ps -aux
	
查看所有服务的默认启动状态
# chkconfig
	
查看当前系统运行级别
# runlevel
	
查看系统，cpu ，内存 的使用状态
# top 
	
杀死  php-fpm 所有进程
# killall php-fpm
	
设置系统时间
# date -s "2007-08-03 14:15:00"
	
```	







## 防火墙设置

centos 系统自带的防火墙会拒绝 80 端口， 443 端口访问，这里直接把防火墙服务器停止了。统一使用网页后台的防火墙分组配置

```
查看防火墙版本
# firewall-cmd --version

查看防火墙状态
# firewall-cmd --state

# systemctl stop  firewalld
# systemctl disable firewalld
```


## mysql 数据库安装 （yum方式）

[参考链接](https://www.jianshu.com/p/7cccdaa2d177)

### 1 添加 MySQL YUM 源

```
$wget 'https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm'
$sudo rpm -Uvh mysql57-community-release-el7-11.noarch.rpm
$yum repolist all | grep mysql

```

### 2 安装 mysql 最新版本

```
安装最新版本
$ sudo yum install mysql-community-server

查看生成的 mysql 临时密码
$ sudo grep 'temporary password' /var/log/mysqld.log

输出如下：
 A temporary password is generated for root@localhost: djjgdTrXV5.)


```

### 3 启动 mysql

```
启动
sudo service mysqld start 
sudo systemctl start mysqld  #CentOS 7

设置开机启动
sudo systemctl enable mysqld

查看启动状态
systemctl list-unit-files | grep mysql

停止
sudo service mysqld stop

查看运行状态
sudo systemctl status mysqld
```

### 4 root 登录，配置
	
```
输入命令，回车，然后输入刚才生成的临时密码
# mysql -u root -p 

重新设置初始化 root 用户密码
>ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_pass_word!';

// 游戏连接配置
>grant all on *.* to 'gameuser'@'127.0.0.1' identified by "your_pass_word!";
>grant all on *.* to 'gameuser'@'localhost' identified by "your_pass_word!";


// 客户端工具访问配置 (这个很重要，密码一定要尽量复杂)
>grant all privileges on *.* to user_name@"%" identified by "your_pass_word!";         

>flush privileges;
>use mysql;
>select host,user from user;

```	

### msyql 配置文件地址

	/etc/my.cnf

## nginx 服务器安装

[参考资源](https://qizhanming.com/blog/2018/08/06/how-to-install-nginx-on-centos-7)

### 添加 yum 源

```
sudo rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

安装之后，可以查看一下
sudo yum repolist
```


### 安装 nginx

```
yum 安装 Nginx，非常简单，一条命令。
$ sudo yum install nginx

设置开机启动
$ sudo systemctl enable nginx

启动服务
$ sudo systemctl start nginx

重新启动
$ sudo systemctl restart nginx

重新启动
$ sudo systemctl reload nginx

检测配置文件是否正确，重启前必须检测一下
#nginx -t -c /etc/nginx/nginx.conf


查看nginx 运行状态
$ ps -ef | grep nginx
$ netstat -na | grep 80

注意：
在浏览器里面输入 ip 地址，查询是否正常， 如果进程以及在运行，但是网页打不开，应该是防火墙屏蔽了 80 端口

停止防火墙服务
# systemctl stop  firewalld

```


### 配置 nginx

```
nginx 配置文件目录： /etc/nginx/
日志文件目录： /var/log/nginx/

```

### nginx 下载服务器配置

```
1> nginx.conf 中配置

 # add by linux_wuliqiang www_file server 
    server {
        charset utf-8;
        client_max_body_size 4G;
        listen  8090;  
        server_name localhost;
        root /server/www_file;
        location / {
                auth_basic   "Restricted";  
                auth_basic_user_file /etc/nginx/pass_file;
                autoindex on;
                autoindex_exact_size on;
                autoindex_localtime on;  
        }
    }
    

 2> 登录用户名密码设置

  增加一个登录用户，用户名为 userxxx , 密码为  123456
  # printf "userxxx:$(openssl passwd -crypt 123456)\n" >> /etc/nginx/pass_file  

```

### nginx https 服务器配置

```
	现在阿里云后台购买免费的ssl证书，证书通过后，下载 nginx 格式文件
	修改Nginx配置文件，让其包含新标记的证书和私钥：
	server {
        listen       443 ssl;
        server_name  openbook.wiki;

        ssl_certificate      /etc/nginx/cert/openbook.wiki.pem;
        ssl_certificate_key  /etc/nginx/cert/openbook.wiki.key;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
            root   /server/www;
            index  index.html index.htm;
        }
    }
```
	
## python 环境配置

### 安装 pip 

```
# yum -y install epel-release
# yum install python-pip
# pip install --upgrade pip

先安装 gcc 编译环境
# yum install gcc

安装开发工具包
# yum groupinstall "Development tools"

执行此代码，要不然安装 uwsgi 会报错
# yum install -y python-devel

```

### 安装 python 3.7
python 2.x 版本运行 flask 会报出编码问题错误，推荐升级到 pythong 3 解决编码问题

```
安装依赖 
# cd 
# yum install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
# yum install wget
# yum install libffi-devel
# yum install gcc

下载源码包
# wget "https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz"
# tar -zxvf Python-3.7.0.tgz

新建安装目录
# mkdir /usr/local/python3

# cd Python-3.7.0
# ./configure --prefix=/usr/local/python3
# make
# lsmake install

设置环境变量
# cd 
# vi .bash_profile 

增加如下配置：
export PATH=$PATH:/usr/local/python3/bin

```


### 设置 python 虚拟环境

注意：由于项目编码问题，推荐使用 python3虚拟环境，此处可以跳过！！
python2 使用 virtualenv 来创建虚拟环境

```
安装虚拟环境
#pip install virtualenv==16.4.3

创建虚拟环境 （会在当前目录生成一个 pyvenv 目录, 目录名称可以根据自己需要随便起）
# cd /server/app/
# virtualenv myenv

激活虚拟环境
# source /server/app/myenv/bin/activate

查看 python 可执行文件目录
# which python  

退出虚拟环境
# deactivate 

```

python3 默认自带了虚拟环境工具 pyvenv
```
# cd /server/app/

创建虚拟环境
# pyvenv spider_env

激活虚拟环境
# source /server/app/spider_env/bin/activate

退出虚拟环境
# deactivate 

```


### 安装 python 依赖库


```
激活虚拟环境
# source /server/app/spider_env/bin/activate

在虚拟环境中执行命令安装：

pip install --upgrade pip

pip install uwsgi==2.0.18
pip install Flask==1.0.2
pip install Flask-Bootstrap==3.3.7.1
pip install Flask-SQLAlchemy==2.3.2
pip install lxml==4.3.2
pip install PyMySQL==0.9.3
pip install Scrapy==1.6.0
pip install xlrd==1.2.0
pip install w3lib==1.20.0

```

	
### wusig + nginx 方式部署 flask 应用


[官方参考文档](https://dormousehole.readthedocs.io/en/latest/deploying/uwsgi.html)
[参考文档-推荐](https://henulwj.github.io/2016/04/18/flask-uwsgi-nginx/)

```


安装 pip 
# yum -y install epel-release
# yum install python-pip
# pip install --upgrade pip

uwsgi 服务安装   
# pip install uwsgi
	

```

1 创建uwsgi的配置文件 /server/app/uwsgiconfig.ini（记得把后面的注释删掉）
```
[uwsgi]
chdir=/server/app/uwsgi # 指定项目目录
home=/server/app/spider_env # 指定python虚拟环境
module=qqweb # 关键之处，让uwsgi能和python的工程联动起来； 否则会出现internal error；
callable=app # 指定uWSGI加载的模块中哪个变量将被调用
master=true # 启动主线程
processes=4 # 设置工作进程的数量
threads=2 # 设置每个工作进程的线程数
socket=/tmp/uwsgi_qqweb.sock # 指定socket地址
vacuum=true # 当服务器退出时自动删除unix socket文件和pid文件
daemonize=/server/app/uwsgi/log/qqweb.log # 进程在后台运行，并将日志打印到指定文件
pidfile=/server/app/uwsgi/qqweb.pid # 在失去权限前，将主进程pid写到指定的文件
uid=10001 # uWSGI服务器运行时的用户id
gid=10001 # uWSGI服务器运行时的用户组id
procname-prefix-spaced=qqweb # 指定工作进程名称的前缀
thunder-lock=true   //惊群效应避免


# uwsgi 相关启动命令
启动uwsgi：uwsgi --ini config.ini
停止uwsgi：uwsgi --stop uwsgi.pid
重新加载配置：uwsgi --reload uwsgi.pid

配置到开机启动中，/etc/rc.local 增加如下配置
uwsgi /server/app/uwsgi/config.ini

在centos7中，/etc/rc.d/rc.local的权限被降低了，所以需要执行如下命令赋予其可执行权限
chmod +x /etc/rc.d/rc.local

```

2  接下来配置nginx进行反向代理 
```
修改配置文件： /etc/nginx/conf.d/qqweb.conf

server {
    listen 80;
    server_name openbook.wiki;
    charset utf-8;
    client_max_body_size 5M;
    location / {
        include uwsgi_params;
        uwsgi_pass unix:/tmp/uwsgi_qqweb.sock;
    }
    location /static {
        alias /home/www/site/static;
    }
}

# 重启nginx服务器
service nginx restart

```

3 访问网站http://xxxx.com 测试是否OK



