---
layout: post
title:  "PHP 获取微信小游戏客户端对应的 IP 地址"
date:   2019-03-05 15:20:18 +0800
categories: php
tags: php 微信小游戏  IP地址
---

* content
{:toc}


## PHP 获取微信小游戏客户端对应的 IP 地址

微信小游戏使用了代理协议，php 服务器端 REMOTE_ADDR 并不是客户端真正的 ip 地址，

HTTP_ALI_CDN_REAL_IP 才是真正的客户端 ip 地址

```
/**
     * 得到客户端的真实 IP 地址
     *
     * 备注： 可以 var_dump($_SERVER); 输出整个 $_SERVER 变量，去里面查找真正属于自己用到的 ip 地址
     */
    public static function ClientIp()
    {
        $ip = null;

        if (isset($_SERVER["HTTP_ALI_CDN_REAL_IP"]))   // 微信小游戏环境中，客户端真实的 ip 地址
        {
            $ip = $_SERVER["HTTP_ALI_CDN_REAL_IP"];
        }


//        else if (isset($_SERVER["HTTP_CLIENT_IP"]))
//        {
//            $ip = $_SERVER["HTTP_CLIENT_IP"];
//        }
//
//        else if (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
//        {
//            $ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
//        }
//
//        else if (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
//        {
//            $ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
//        }

        if(null == $ip)
        {
            $ip = $_SERVER["REMOTE_ADDR"];
        }

        return $ip;
    }
```






