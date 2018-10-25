# 
# 备注：	启动本地网站服务器程序，
#		执行脚本后，直接在浏览器里面访问 http://127.0.0.1:4000/ 直接可以在本地查看博客的效果
#		本地环境配置：参考 https://www.jekyll.com.cn/docs/installation/
# 


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



# echo curr dir is $DIR
cd $DIR

# --baseurl '' 参数， 设置本地浏览器运行时默认的网站路径为 

jekyll serve --baseurl ''