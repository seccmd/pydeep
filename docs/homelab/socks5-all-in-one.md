# Socks5 all in one

## Proxychains

```Bash
apt update && apt install -y curl wget proxychains

nano /etc/proxychains.conf
socks5 192.168.1.100 1080 

# 测试代理是否生效​​：
proxychains curl -I http://www.google.com

```



**上帝模式：所有命令走代理​**​：牛B

```Bash
proxychains bash  # 启动一个子 Shell，所有命令自动走代理
curl -I http://www.google.com  # 现在无需手动加 proxychains
```



## **临时设置代理（当前终端生效）**

```Bash
export http_proxy="http://192.168.1.100:8080"
export https_proxy="http://192.168.1.100:8080"
export ftp_proxy="http://<代理IP>:<端口>"       # FTP 代理
export no_proxy="localhost,127.0.0.1"          # 不走代理的地址
curl -I http://www.google.com  # 检查是否能访问外网

# 直接在命令前设置代理​
http_proxy="http://192.168.1.100:8080" curl -I http://www.google.com

# 代理服务器认证（用户名/密码）​
export http_proxy="http://用户名:密码@192.168.1.100:8080"
export https_proxy="http://用户名:密码@192.168.1.100:8080"
unset http_proxy
unset https_proxy
unset ftp_proxy

```



## **Git 代理设置**

```Bash
git config --global http.proxy "http://192.168.1.100:8080"
git config --global https.proxy "http://192.168.1.100:8080"

git config --global --unset http.proxy
git config --global --unset https.proxy

```



## **Docker 代理设置**

```JSON
sudo nano /etc/docker/daemon.json

{
  "proxies": {
    "default": {
      "httpProxy": "http://192.168.1.100:8080",
      "httpsProxy": "http://192.168.1.100:8080",
      "noProxy": "localhost,127.0.0.1"
    }
  }
}

```
