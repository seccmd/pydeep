# Splunk All in One

替代工具推荐 Log Parser Studio：免费图形化工具，支持SQL语法直接查询日志文件。 ELK Stack：大型日志分析场景，可搭建本地Elasticsearch+Kibana实时可视化平台。

### Docker一键安装Splunk

* [splunk单节点容器部署 - kylingx - 博客园](https://www.cnblogs.com/kylingx/p/12942334.html)

```Bash
apt install docker.io
docker ps
docker cp /home/vagrant/test.txt 10704c9eb7bb:/root/test.text

# 免费版 Free 许可证 - 个人学习或小型监控需求，每天新建的索引量为 500MB/天。​​永久有效​​（无时间限制）仅支持 ​​1个用户
docker run -it --name socx_free -e SPLUNK_START_ARGS=--accept-license -e SPLUNK_LICENSE_URI=Free -p 8008:8000 splunk/splunk:latest
# 试用版（Trial License）短期测试企业版功能（如集群、身份验证、分布式搜索等）每日索引配额​​ 500 MB，首次安装后 ​​60天​​（过期自动转为免费版）
docker run -d --name socx_trial -e SPLUNK_START_ARGS=--accept-license -e SPLUNK_PASSWORD=Spassw0rd -p 8009:8000 -p 9997:9997 splunk/splunk start

# Docker 数据路径: 
/opt/splunk/var/lib/splunk
# 管理控制台：admin - Spassw0rd
http://47.76.253.98:8008/
# 数据接收-默认端口：9997
```

**Splunk Environment Variables:**

```Markdown
  ____        _             _      __
 / ___| _ __ | |_   _ _ __ | | __  \ \
 \___ \| '_ \| | | | | '_ \| |/ /   \ \
  ___) | |_) | | |_| | | | |   <    / /
 |____/| .__/|_|\__,_|_| |_|_|\_\  /_/
       |_|
========================================

Environment Variables:
  * SPLUNK_USER - user under which to run Splunk (default: splunk)
  * SPLUNK_GROUP - group under which to run Splunk (default: splunk)
  * SPLUNK_HOME - home directory where Splunk gets installed (default: /opt/splunk)
  * SPLUNK_START_ARGS - arguments to pass into the Splunk start command; you must include '--accept-license' to start Splunk (default: none)
  * SPLUNK_PASSWORD - password to log into this Splunk instance, you must include a password (default: none)
  * SPLUNK_ROLE - the role of this Splunk instance (default: splunk_standalone)
      Acceptable values:
        - splunk_standalone
        - splunk_search_head
        - splunk_indexer
        - splunk_deployer
        - splunk_license_master
        - splunk_cluster_master
        - splunk_heavy_forwarder
  * SPLUNK_LICENSE_URI - URI or local file path (absolute path in the container) to a Splunk license
  * SPLUNK_STANDALONE_URL, SPLUNK_INDEXER_URL, ... - comma-separated list of resolvable aliases to properly bring-up a distributed environment.
                                                     This is optional for standalones, but required for multi-node Splunk deployments.
  * SPLUNK_BUILD_URL - URL to a Splunk build which will be installed (instead of the image's default build)
  * SPLUNK_APPS_URL - comma-separated list of URLs to Splunk apps which will be downloaded and installed

Examples:
  * docker run -it -e SPLUNK_PASSWORD=helloworld -p 8000:8000 splunk/splunk start
  * docker run -it -e SPLUNK_START_ARGS=--accept-license -e SPLUNK_PASSWORD=helloworld -p 8000:8000 -p 8089:8089 splunk/splunk start
  * docker run -it -e SPLUNK_START_ARGS=--accept-license -e SPLUNK_LICENSE_URI=http://example.com/splunk.lic -e SPLUNK_PASSWORD=helloworld -p 8000:8000 splunk/splunk start
  * docker run -it -e SPLUNK_START_ARGS=--accept-license -e SPLUNK_INDEXER_URL=idx1,idx2 -e SPLUNK_SEARCH_HEAD_URL=sh1,sh2 -e SPLUNK_ROLE=splunk_search_head --hostname sh1 --network splunknet --network-alias sh1 -e SPLUNK_PASSWORD=helloworld -e SPLUNK_LICENSE_URI=http://example.com/splunk.lic splunk/splunk start
```

### 客户端调研专项 todo

<https://download.splunk.com/products/universalforwarder/releases/8.2.5/windows/splunkforwarder-8.2.5-77015bc7a462-x64-release.msi>

* <https://www.invictus-ir.com/news/importing-windows-event-log-files-into-splunk>
* <https://cybersecthreat.com/zh/2020/07/08/import-windows-event-log-to-splunk/>


以下是 Splunk Universal Forwarder 在 Windows 系统上的快速配置步骤，结合最佳实践整理而成：

---

### ⚙️ **1. 安装 Splunk Universal Forwarder**
- **下载**：  
  从 [Splunk 官网](https://www.splunk.com/en_us/download/universal-forwarder.html) 下载 Windows 版 `.msi` 安装包。
- **安装过程**：  
  - 双击安装包，接受许可协议。  
  - 安装目录默认：`C:\Program Files\SplunkUniversalForwarder`。  
  - **账户权限**：选择 **`本地系统账户`**（Local System），确保可访问系统日志和性能数据[citation:1][citation:2]。  
  - **配置接收端**：在安装向导中填写 Splunk 索引器的 IP 和端口（默认 `9997`）[citation:2][citation:4]。

---

### 🔧 **2. 配置转发到 Splunk 索引器**
#### **方法一：通过命令行（推荐快速配置）**
```powershell
# 进入 Splunk 目录
cd "C:\Program Files\SplunkUniversalForwarder\bin"

# 添加索引器地址（替换 <索引器IP>）
splunk add forward-server <索引器IP>:9997

# 启用 Windows 事件日志收集
splunk add monitor WinEventLog:://*
splunk enable eventlog

# 重启服务
splunk restart
```

#### **方法二：手动修改配置文件**

1. 编辑 `outputs.conf`：\
   路径：`C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf`\
   添加以下内容：
```ini
   [tcpout]
   defaultGroup = splunk_indexers
   [tcpout:splunk_indexers]
   server = <索引器IP>:9997
```
2. 重启服务：\
   通过服务管理器重启 `SplunkForwarder` 服务，或命令行执行：
```cmd
   "C:\Program Files\SplunkUniversalForwarder\bin\splunk" restart
```

***

### 📢 **3. 配置日志收集**

* **基础监控**（如系统事件日志）：\
  通过命令行启用（见上述步骤）或编辑 `inputs.conf`：
  ```ini
  [monitor://WinEventLog:://*]
  disabled = 0
  index = main   # 指定索引名称（需与 Splunk 服务端匹配）
  ```
* **自定义日志路径**（如应用日志）：
  ```ini
  [monitor://C:\YourApp\Logs\*.log]
  sourcetype = your_app_log
  index = custom_index
  ```

***

### ✅ **4. 验证配置**

1. **服务状态**：\
   运行 `services.msc`，确认 `SplunkForwarder` 服务状态为 **正在运行**。
2. **日志验证**：\
   在 Splunk Web 界面搜索：
   ```
   index=<指定的索引名> host=<Windows主机名>
   ```
   若看到事件日志或自定义日志，说明配置成功\[citation:4]。

***

### ⚠️ **注意事项**

1. **端口开放**：\
   确保 Splunk 索引器的 `9997` 端口已启用（在索引器设置中：**Settings → Forwarding and Receiving → Configure Receive**）\[citation:2]\[citation:3]。
2. **权限问题**：\
   若需监控远程共享日志，需使用域账户（非本地系统账户）安装\[citation:2]。
3. **高级需求**（如 DNS 日志）：\
   需额外安装 Splunk Add-on for Microsoft DNS，并配置 `inputs.conf` 监控 `dns.log`\[citation:5]。

***

### 🔄 **故障排查**

* **检查日志**：\
  查看转发器日志：`C:\Program Files\SplunkUniversalForwarder\var\log\splunk\splunkd.log`。
* **测试连通性**：\
  在 Windows 主机执行 `telnet <索引器IP> 9997`，确认端口可达。

> 💡 **提示**：如需批量部署，可通过 Splunk Deployment Server 集中管理配置\[citation:1]。完整文档参考 [Splunk 官方指南](https://docs.splunk.com/Documentation)。

````



测试

```Markdown
## 服务端配置
## C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf
````

\[tcpout] defaultGroup = default-autolb-group

\[tcpout:default-autolb-group] server = 47.76.253.98:9997

\[tcpout-server://47.76.253.98:9997]

```

## 新建配置文件
## C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf 
```

\[monitor://E:\splunk\_analysis\*.evtx] disabled = 0 sourcetype = preprocess-winevt host = pc\_machine index = wineventlog

```

## 启动服务(管理员权限) - 通过服务管理器重启 `SplunkForwarder` 服务，或命令行执行：
"C:\Program Files\SplunkUniversalForwarder\bin\splunk" restart

## 问题
- 自动绑定本地8089端口，具体用途不明。
```

### Ubuntu 22.04 安装Splunk Enterprise服务端

* <https://www.cnblogs.com/autopwn/p/18540982>

```Markdown
# 下载安装包，这里采用安装Splunk Enterprise 8.2.5版本
wget -O splunk-8.2.5-77015bc7a462-linux-2.6-amd64.deb [https://download.splunk.com/products/splunk/releases/8.2.5/linux/splunk-8.2.5-77015bc7a462-linux-2.6-amd64.deb](https://download.splunk.com/products/splunk/releases/8.2.5/linux/splunk-8.2.5-77015bc7a462-linux-2.6-amd64.deb)

# 执行安装
sudo dpkg -i splunk-8.2.5-77015bc7a462-linux-2.6-amd64.deb

# 正常情况下是没有报错直接安装成功，然后查找安装成功的路径，并执行splunk，
# 根据向导配置登录splunk的用户名和密码，成功之后并启动服务。
/opt/splunk/bin/splunk start

上述执行都没有问题的话，会在本地侦听8000端口，然后访问该主机的IP和8000端口即可正常访问Splunk服务端了。
[https://127.0.0.1:8000](https://127.0.0.1:8000)
http://47.76.253.98:8000/


## Uninstall Splunk
./splunk disable boot-start
dpkg -r splunk
```

IISLog

```Markdown
## IIS日志默认存放位置​

- Windows Server 2003  C:\Windows\System32\LogFiles\
- Windows Server 2008  C:\inetpub\logs\LogFiles\

路径示例：C:\inetpub\logs\LogFiles\W3SVC1（默认站日志）
日志文件名格式：u_exYYMMDD.log（如 u_ex240624.log）

​​## 子目录命名规则​​

- W3SVC<网站ID>（例如W3SVC1对应默认网站）。
​​- W3SVC1​​：通常对应​​默认网站（Default Web Site）​​，ID 固定为 1。
​​- W3SVC2​​：表示用户创建的​​第二个网站​​（例如新增的站点或应用），ID 按创建顺序递增（如2、3等）

如何确认网站ID​​：打开IIS管理器 → 选中目标网站 → 双击“日志”图标 → 查看路径中的文件夹名称
```
