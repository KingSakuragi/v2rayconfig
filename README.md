#### 准备工作
域名,vps(centos7),SSL,ssh工具 ftp 工具 
#### Linux 环境
###### 防火墙
> 查看防火墙服务&ensp;&ensp;&ensp;&thinsp;&ensp;&ensp;&ensp;&ensp;&thinsp;&thinsp; sudo firewall-cmd --list-service <br>
> 查看防火墙状态 &ensp;&ensp;&ensp;&ensp;&ensp;&thinsp;&thinsp;&thinsp; &ensp; firewall-cmd --state  
> 关闭防火墙 &ensp;&ensp;&ensp;&ensp;&ensp;&thinsp; &ensp; &ensp;&ensp; &ensp;   systemctl stop firewalld.service  
> 禁止开机启动防火墙 &ensp;&ensp;&ensp;&ensp; systemctl disable
firewalld.service <br>
> 查看已开放端口 &ensp;&ensp;&ensp;&ensp;  &ensp;&ensp;&ensp;
firewall-cmd --zone=public --list-ports <br>
> 添加开放端口&ensp;&ensp;&ensp;&ensp;  &ensp;&ensp;&ensp;&ensp;&ensp; 
firewall-cmd --zone=public --add-port=80/tcp --permanent
###### 工具

```
1.yum install net-tools
2.yum install zip unzip
3.yum -y install wget
```
###### 软件
- Nginx
1. 安装
```
 1. sudo yum install nginx            安装
 2. sudo systemctl enable nginx       开机启动
 3. sudo systemctl start nginx        启动
 4. sudo systemctl restart nginx      重启
 5. sudo systemctl reload nginx       重新加载配置
```

2. 配置
3. 1. 配置文件位置   /etc/nginx/nginx.conf
   2. 配置文件
   ```
   
   server {
         listen 443 ssl   http2 default_server;
         listen [::]:443 ssl http2 default_server;
         server_name  www.kingking.fun;
         root         /usr/share/nginx/html;

         ssl_certificate /etc/ssl/cert.crt;
         ssl_certificate_key /etc/ssl/private/cert.key;
         ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
         ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
         ssl_prefer_server_ciphers on;
         ssl_session_cache shared:SSL:10m;
         ssl_session_timeout 10m;

        location / {
            index index.html;           
        }

        location /ray { 
             proxy_redirect off;
             proxy_pass http://127.0.0.1:10000;
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection "upgrade";
             proxy_set_header Host $http_host;

             proxy_set_header X-Real-IP $remote_addr;   
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         }
        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
   ```
- v2ray 
1. 服务端安装[参考文档]( https://www.4spaces.org/digitalocean-build-v2ray-0-1)
  ``` 
   wget https://install.direct/go.sh
   bash go.sh 
   ## 启动
      systemctl start v2ray
   ## 停止
      systemctl stop v2ray
   ## 重启
      systemctl restart v2ray
   ## 开机自启
      systemctl enable v2ray
```
2. 1. 配置文件位置   /etc/v2ray/config.json
   2. 配置文件
      
  ``` json
 {
    "log":{
        "access":"/var/log/v2ray/access.log",
        "error":"/var/log/v2ray/error.log",
        "loglevel":"warning"
    },
    "inbounds":[
        {
            "port":10000,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"uuid", #可以网上搜下uuid生成工具
                        "level":1,
                        "alterId":64
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"/ray"
                }
            }
        }
    ],
    "outbounds":[
        {
            "protocol":"freedom",
            "settings":{

            },
            "tag":"direct"
        },
        {
            "protocol":"blackhole",
            "settings":{

            },
            "tag":"blocked"
        }
    ],
    "routing":{
        "rules":[
            {
                "type":"field",
                "ip":[
                    "0.0.0.0/8",
                    "10.0.0.0/8",
                    "100.64.0.0/10",
                    "127.0.0.0/8",
                    "169.254.0.0/16",
                    "172.16.0.0/12",
                    "192.0.0.0/24",
                    "192.0.2.0/24",
                    "192.168.0.0/16",
                    "198.18.0.0/15",
                    "198.51.100.0/24",
                    "203.0.113.0/24",
                    "::1/128",
                    "fc00::/7",
                    "fe80::/10"
                ],
                "outboundTag":"blocked"
            }
        ]
    }
}
   ```

- v2ray 客户端mac

1.  mac 命令行安装

```
brew cask install v2rayu
```
2.  配置图片
  [https://ibb.co/zN6Y1KG ](https://ibb.co/zN6Y1KG )

``` json
{
    "log":{
        "error":"",
        "loglevel":"debug",
        "access":""
    },
    "inbounds":[
        {
            "listen":"127.0.0.1",
            "protocol":"socks",
            "settings":{
                "ip":"",
                "userLevel":0,
                "timeout":360,
                "udp":false,
                "auth":"noauth"
            },
            "port":"1080"
        },
        {
            "listen":"127.0.0.1",
            "protocol":"http",
            "settings":{
                "timeout":360
            },
            "port":"1087"
        }
    ],
    "outbounds":[
        {
            "mux":{
                "enabled":false,
                "concurrency":8
            },
            "protocol":"vmess",
            "streamSettings":{
                "wsSettings":{
                    "path":"/ray",
                    "headers":{
                        "host":"www.baidu.com"#自己域名
                    }
                },
                "tlsSettings":{
                    "serverName":"www.baidu.com",#自己域名
                    "allowInsecure":true
                },
                "security":"tls",
                "network":"ws"
            },
            "tag":"agentout",
            "settings":{
                "vnext":[
                    {
                        "address":"www.baidu.com",
                        "users":[
                            {
                                "id":"uuid", #需要和服务端对应
                                "alterId":64,
                                "level":1,
                                "security":"aes-128-gcm"
                            }
                        ],
                        "port":443
                    }
                ]
            }
        },
        {
            "tag":"direct",
            "protocol":"freedom",
            "settings":{
                "domainStrategy":"AsIs",
                "redirect":"",
                "userLevel":0
            }
        },
        {
            "tag":"blockout",
            "protocol":"blackhole",
            "settings":{
                "response":{
                    "type":"none"
                }
            }
        }
    ],
    "dns":{
        "servers":[
            ""
        ]
    },
    "routing":{
        "strategy":"rules",
        "settings":{
            "domainStrategy":"IPIfNonMatch",
            "rules":[
                {
                    "outboundTag":"direct",
                    "type":"field",
                    "ip":[
                        "geoip:cn",
                        "geoip:private"
                    ],
                    "domain":[
                        "geosite:cn",
                        "geosite:speedtest"
                    ]
                }
            ]
        }
    },
    "transport":{

    }
}
```


- v2ray 客户端 windows

```
安装需要两个文件，自行百度
参考  https://github.com/v2ray/v2ray-core/releases
      https://github.com/2dust/v2rayN/releases
```
