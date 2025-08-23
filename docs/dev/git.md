# git 网络代理

### Flow

```
[Working Directory] --> $git add --> [Staging Area] --> $git commit --> [Local Repository] --> $git push/pull --> [Remote Repository]
```

### 示例：通过 SOCKS5 代理访问 GitHub

git config --global http.proxy 'socks5h://127.0.0.1:1080'

curl --socks5-hostname 127.0.0.1:1080 <https://api.ipify.org>

### Git 设置 SOCKS5 代理

git config --global http.proxy socks5://127.0.0.1:1080

git config --global https.proxy socks5://127.0.0.1:1080

git config --global http.proxy socks5://用户名:密码@代理IP:端口

git config --global https.proxy socks5://用户名:密码@代理IP:

git config --global https.proxy socks5://user123:pass456@192.168.1.1:1080

### 编辑 ~/.gitconfig 文件，添加：

```YAML
[http]
    proxy = socks5://用户名:密码@代理IP:端口
[https]
    proxy = socks5://用户名:密码@代理IP:端口
```

### 验证与取消

```Bash
git config --global --get http.proxy
git config --global --get https.proxy

git config --global --unset http.proxy
git config --global --unset https.proxy
```
