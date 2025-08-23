# **safeline**

https://github.com/chaitin/safeline

今天给大家推荐一个广受好评的免费开源WAF：**safeline**

safeline是一款足够简单、足够好用、足够强的免费 WAF。基于业界领先的语义引擎检测技术，作为反向代理接入，保护你的网站不受黑客攻击。

核心检测能力由智能语义分析算法驱动，专为社区而生，不让黑客越雷池半步。



## 安装指南

**配置需求**

- 操作系统：Linux
- 指令架构：x86_64
- 软件依赖：Docker 20.10.6 版本以上
- 软件依赖：Docker Compose 2.0.0 版本以上
- 最小化环境：1 核 CPU / 1 GB 内存 / 10 GB 磁盘

**一键安装**

```bash
bash -c "$(curl -fsSLk https://waf-ce.chaitin.cn/release/latest/setup.sh)"
```

## 快速使用

**登录**

浏览器打开后台管理页面 https://:9443。根据界面提示，使用 支持 TOTP 的认证软件 扫描二维码，然后输入动态口令登录：

添加防护主机，测试攻击，正常执行。除了docker版本坑了以下，一切都很丝滑，很好的体验。产品质量点赞。

**使用**

开关服务：docker-compose stop

安装目录：/data/safeline

**评价：**

看一下这个产品， 我试用了一下，体验很好，很丝滑。

但是想做好一款产品，使用很简单方便，做起来挺难的。



**报错：升级 Docker Compose 2.0.0 版**

```markdown
** docker: 'compose' is not a docker command. ** 
# Docker Compose 2.0.0 版本以上 版本太低，升级系统默认安装的版本：1.25 升级到 2.0

# If installed via apt-get:
sudo apt-get remove docker-compose

# curl + grep 获取最新版本
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')

# Finally, download to your favorite $PATH-accessible location and set permissions:
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION
```





# Curiefense

Curiefense 是一个 **API 优先、面向 DevOps 的 Web 防御 HTTP-Filter** **适配器，用于** [**特使**](https://www.envoyproxy.io/)**和**[**嘎**](https://nginx.org/en/).它提供多种安全技术（WAF、应用层 DDoS 防护、爬虫程序管理等）以及实时流量监控和透明度。

Curiefense 是完全可编程.所有配置数据（安全规则集、策略等）都可以单独维护，也可以作为不同环境的不同分支进行维护。所有更改都经过版本控制，并且可以随时进行还原。

## 安装部署

**先决条件**：Ubuntu 21.04

第一步：安装 Docker

```bash
sudo apt update
sudo apt install -y git docker.io docker-compose libpq-dev python3-dev gcc python3-psycopg2 vim
sudo usermod -aG docker $(whoami) && sudo -i -u $(whoami)
```



第二步：从 GitHub 获取最新代码以开始使用：

```bash
git clone https://github.com/curiefense/curiefense.git
cd curiefense/deploy/compose/
docker-compose up

docker-compose ps

```



**现象总结：暂时觉得放弃。**

优势：

集成了所有的组件，功能强大，本来是好意，但是，另一个角度就是依赖太多，维护成本高。

劣势：

界面操作功能太强，不直观和易用性差，学习成本太高。

默认安装后，有一个容器报错：`trafficmetricsexporter    | ERROR:traffic-metrics-exporter:No operations to execute`

默认演示案例，兼容性不足，而且依赖14个容器，这个项目太复杂了，学习成本，部署和维护难度很大。

```
:~/Desktop/curiefense/deploy/compose$ docker-compose ps
         Name                       Command               State                                                      Ports                                                    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
confserver               /usr/bin/dumb-init -- /ent ...   Up      0.0.0.0:30000->80/tcp,:::30000->80/tcp                                                                      
curieproxyenvoy          /start_curiefense.sh             Up      10000/tcp, 0.0.0.0:30444->443/tcp,:::30444->443/tcp, 0.0.0.0:30445->444/tcp,:::30445->444/tcp,              
                                                                  0.0.0.0:30081->80/tcp,:::30081->80/tcp, 0.0.0.0:8001->8001/tcp,:::8001->8001/tcp,                           
                                                                  0.0.0.0:30082->81/tcp,:::30082->81/tcp                                                                      
curieproxyngx            /bin/sh -c service cron st ...   Up      0.0.0.0:31081->31081/tcp,:::31081->31081/tcp, 0.0.0.0:31082->31082/tcp,:::31082->31082/tcp,                 
                                                                  0.0.0.0:31444->31083/tcp,:::31444->31083/tcp, 0.0.0.0:31445->31084/tcp,:::31445->31084/tcp,                 
                                                                  0.0.0.0:8999->8999/tcp,:::8999->8999/tcp                                                                    
curiesync                /usr/bin/dumb-init /bin/ba ...   Up                                                                                                                  
echo                     /bin/echo-server                 Up      0.0.0.0:8080->8080/tcp,:::8080->8080/tcp                                                                    
elasticsearch            /bin/tini -- /usr/local/bi ...   Up      0.0.0.0:9200->9200/tcp,:::9200->9200/tcp, 9300/tcp                                                          
grafana                  /run.sh                          Up      0.0.0.0:30300->3000/tcp,:::30300->3000/tcp                                                                  
juiceshop                /nodejs/bin/node /juice-sh ...   Up      0.0.0.0:3000->3000/tcp,:::3000->3000/tcp                                                                    
kibana                   /bin/tini -- /usr/local/bi ...   Up      0.0.0.0:5601->5601/tcp,:::5601->5601/tcp                                                                    
mongodb                  /opt/bitnami/scripts/mongo ...   Up      0.0.0.0:27017->27017/tcp,:::27017->27017/tcp                                                                
prometheus               /bin/prometheus --config.f ...   Up      0.0.0.0:9090->9090/tcp,:::9090->9090/tcp                                                                    
redis                    docker-entrypoint.sh /bin/ ...   Up      0.0.0.0:6379->6379/tcp,:::6379->6379/tcp                                                                    
trafficmetricsexporter   python3 ./traffic_metrics_ ...   Up      8911/tcp                                                                                                    
uiserver                 /usr/bin/start.sh                Up      0.0.0.0:30443->443/tcp,:::30443->443/tcp, 0.0.0.0:30080->80/tcp,:::30080->80/tcp     
```



