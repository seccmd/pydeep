# API安全


## 技术方案

API防护的最佳实践（From Gartner) https://www.freebuf.com/news/306073.html

**rest sec cheat sheet** https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html

**owasp api sec** https://owasp.org/www-project-api-security/

阿里云 https://help.aliyun.com/document_detail/164802.html

caofanqi https://github.com/caofanqi/study-security/tree/master/doc

**Redhat**

API 安全防护 https://www.redhat.com/zh/topics/security/api-security

了解 IT 安全防护 https://www.redhat.com/zh/topics/security

什么是 API https://www.redhat.com/zh/topics/api

什么是零信任？
https://www.redhat.com/zh/topics/security/what-is-zero-trust

API 网关能做什么？ https://www.redhat.com/zh/topics/api/what-does-an-api-gateway-do

红帽的混合云安全防护心法 https://www.redhat.com/zh/topics/security/hybrid-cloud-security-approach

红帽 3scale API 管理 https://www.redhat.com/zh/technologies/jboss-middleware/3scale

红帽 OpenShift API 管理 https://www.redhat.com/zh/technologies/cloud-computing/openshift/openshift-api-management



## 开放式API安全防护的七大原则

```
开放式API安全防护的七大原则

在我们日常工作程序开发过程中，难免会涉及与第三方系统进行数据的交互与传递，那么如何保证数据在传输过程中的安全呢（即防窃取）？

API 是模块或者子系统之间交互的接口定义，优秀的系统架构离不开好良好的 API 设计，而一个设计不够完善的 API 则注定会导致系统的后续发展和维护非常困难。

下面我们就来讨论下常用的一些API设计的安全方法。


一、API服务为什么要签名？

首先要明确，接口服务需要解决的三个问题：

请求是否合法：是否是我的信任方

请求是否被篡改：是否被第三方劫持并篡改参数

防止重复请求（防重放）：是否重复请求


二、服务调用流程

1. 接口调用方(客户端)向接口提供方(服务器)申请接口调用账号，申请成功后，接口提供方会给接口调用方一个appId和一个key参数；
2. 客户端携带参数appId、timestamp、sign去调用服务器端的API token，其中sign=加密(appId + timestamp + key)；
3. 客户端拿着api_token 去访问不需要登录就能访问的接口；
4. 当访问用户需要登录的接口时，客户端跳转到登录页面，通过用户名和密码调用登录接口，登录接口会返回一个usertoken, 客户端拿着usertoken 去访问需要登录才能访问的接口；
5. sign的作用是防止参数被篡改，客户端调用服务端时需要传递sign参数，服务器响应客户端时也可以返回一个sign用于客户端校验返回的值是否被非法篡改了。客户端传的sign和服务器端响应的sign算法可能会不同。


三、必要参数介绍

一般 token、timestamp 和 sign 三个参数会在接口中会同时作为参数传递，每个参数都有各自的用途。

3.1 token

Token：访问令牌access token, 用于接口中, 用于标识接口调用者的身份、凭证，减少用户名和密码的传输次数。一般情况下客户端(接口调用方)需要先向服务器端申请一个接口调用的账号，服务器会给出一个appId和一个key, key用于参数签名使用，注意key保存到客户端，需要做一些安全处理，防止泄露。

Token的值一般是UUID，服务端生成Token后需要将token作为key，将一些和token关联的信息作为value保存到缓存服务器中(redis)，当一个请求过来后，服务器就去缓存服务器中查询这个Token是否存在，存在则调用接口，不存在返回接口错误，一般通过拦截器或者过滤器来实现，Token分为两种：

API Token(接口令牌): 用于访问不需要用户登录的接口，如登录、注册、一些基本数据的获取等。获取接口令牌需要拿appId、timestamp和sign来换，sign=加密(timestamp+key)；

USER Token(用户令牌): 用于访问需要用户登录之后的接口，如：获取我的基本信息、保存、修改、删除等操作。获取用户令牌需要拿用户名和密码来换。

关于Token的时效性：token可以是一次性的、也可以在一段时间范围内是有效的，具体使用哪种看业务需要。

3.2 timestamp

timestamp: 时间戳，是客户端调用接口时对应的当前时间戳，时间戳用于防止DoS攻击。

当黑客劫持了请求的url去DoS攻击，每次调用接口时接口都会判断服务器当前系统时间和接口中传递的timestamp的差值，如果这个差值超过某个设置的时间(假如5分钟)，那么这个请求将被拦截掉，如果在设置的超时时间范围内，是不能阻止DoS攻击的。timestamp机制只能减轻DoS攻击的时间，缩短攻击时间。

DoS

DoS是Denial of Service的简称，即拒绝服务，造成DoS的攻击行为被称为DoS攻击，其目的是使计算机或网络无法提供正常的服务。最常见的DoS攻击有计算机网络带宽攻击和连通性攻击。

DoS攻击是指故意的攻击网络协议实现的缺陷或直接通过野蛮手段残忍地耗尽被攻击对象的资源，目的是让目标计算机或网络无法提供正常的服务或资源访问，使目标系统服务系统停止响应甚至崩溃，而在此攻击中并不包括侵入目标服务器或目标网络设备。这些服务资源包括网络带宽，文件系统空间容量，开放的进程或者允许的连接。这种攻击会导致资源的匮乏，无论计算机的处理速度多快、内存容量多大、网络带宽的速度多快都无法避免这种攻击带来的后果。

3.3 sign

nonce：随机值，是客户端随机生成的值，作为参数传递过来，随机值的目的是增加sign签名的多变性。随机值一般是数字和字母的组合，6位长度，随机值的组成和长度没有固定规则。

sign: 一般用于参数签名，防止参数被非法篡改，最常见的是修改金额等重要敏感参数， sign的值一般是将所有非空参数按照升序排序然后将如下数据：

token+key+timestamp+nonce(随机数)
拼接在一起，然后使用某种加密算法进行加密，作为接口中的一个参数sign来传递，也可以将sign放到请求头中。

接口在网络传输过程中如果被黑客挟持，并修改其中的参数值，然后再继续调用接口，虽然参数的值被修改了，但是因为黑客不知道sign是如何计算出来的，不知道sign都有哪些值构成，不知道以怎样的顺序拼接在一起的，最重要的是不知道签名字符串中的key是什么，所以黑客可以篡改参数的值，但没法修改sign的值，当服务器调用接口前会按照sign的规则重新计算出sign的值然后和接口传递的sign参数的值做比较，如果相等表示参数值没有被篡改，如果不等，表示参数被非法篡改了，就不执行接口了。


四、API安全应用原则

4.1 使用 HTTPS

现在的 Web 已经不是之前那个年代，标准的 HTTP 满足不了 Web 安全需求。而各大浏览器供应商开始标记不使用安全层的 URL，你的 API 也可以考虑开始动手做这件事——用 HTTPS。HTTPS 采用传输层安全性协议（TLS）对传输进行加密。这意味着 HTTPS 对客户端和服务器之间的通信进行加密。对 API 而言，HTTPS 意味着从 API 发送的内容是受第三方保护的，但更重要的是这意味着访问凭证是安全的。

4.2 认证

说到访问凭证，避免意外使用 API 的最直接的方法便是确保正确的身份验证。身份验证决定了你是否可访问 API 及如何访问某个 API，即便是对外开放的免费 API 理论上也应当考虑采用身份验证策略以保证安全性。有了身份认证，你可以限制或删除滥用 API 的使用者，让使用者在需要时重新设置凭证，从而保护他们的安全。

4.3 授权

起到和身份验证类似作用的是授权。身份验证和授权的区别在于，身份验证关注的是 API 的使用者是谁，而授权关注的是他们能够访问的内容。举个例子，免费计划用户可能被授权只能访问你所有 API 的某个子集。当你想集成诸如社交登录此类 API 时，用户授权可让应用从社交平台读取他们的配置文件数据。

4.4 限流限速

提到安全，我们不得不提限流限速。当然，如何处理不适当的访问对管理资源也很有用。限流限速是一种限制 API 使用的技术。它不仅在经济上保护资源，但也保证了服务器不会因某次大量的请求而超载。大多数限速的方法都基于时间的：一般会设置一个账单周期来处理 API 总体使用情况，也会用“突发”方法来限制大量涌入的请求。如果你看到 429 HTTP 状态代码，说明你正在被限速。

4.5 验证和净化输入

要攻击 Web 程序最古老的方式之一是输入，即：我们访问数据的方式可能已经改变，但是验证任意用户输入的需要还没有改变。客户端验证有助于防止错误和改善用户体验，但是 API 还需要在对输入执行操作前验证和净化（sanitize）输入——净化策略为删除请求中的恶意或无效代码。验证确保数据满足资源期望的必要条件，例如：类型、形式，甚至是密码结构等因素。

4.6 数据按需开放

采用快捷方式将数据模型直接映射到接口是很诱人，但这不仅会产生冗长的响应、增加带宽使用，而且还会暴露用户不需要访问的数据。举个例子：一个 /user 接口要返回用户信息。它可能只要用户的一些基本信息，而不需要用户的密码/权限。

4.7 勿暴露敏感信息

除了对 API 的输入数据进行净化（sanitize）外，还需要对从中产生的信息进行净化。错误消息对用户了解问题的发生至关重要，但要确保不泄漏任何敏感数据。向终端用户提供 API 内部代码结构的详细信息会为攻击者提供便利，所以一定要确保错误信息的配置不仅能提供足够的信息来帮助用户调试，并提供足够的信息让他们报告问题，但又不足以暴露应用程序的内部工作和敏感数据。

五、总结

随着硬件设备，分布式计算能力的不断提升，大数据处理能力的完善，也许现在还算安全的防护措施，在不久将来可就会变得不堪一击，数据安全的攻防势必是一场持久战，道高一尺魔高一丈，只有不断总结与改进，才能极大可能保护我们的核心数据和用户的权益。

虽然本质上 API 就是拿来用的，但即便某个 API 的使用者全是内部人员，它还是可能会出现安全问题。当然了有些平台也提供 IP 白名单服务，可以进一步防止Open API 被冒用。

为了解决 API 安全问题，在本文我们列举了一系列 API 的最佳实践，希望能够帮助到你。
```



# API网关

## TODO



## 概念定义

API网关（API GATEWAY）是什么？有什么作用？ https://zhuanlan.zhihu.com/p/371986798

## 技术方案选型

开源API网关系统（Kong教程）入门到精通  https://www.jianshu.com/p/a68e45bcadb6

github caofanqi https://github.com/caofanqi/study-security/tree/master/doc

Kong API网关介绍及选型(kong) https://blog.csdn.net/pushiqiang/article/details/95726137

谈谈微服务中的 API 网关（API Gateway）https://www.cnblogs.com/savorboard/p/api-gateway.html

- 我一直在寻思一种最佳的 API 网关的落地方案，以上两种 API 网关有什么问题呢？ 通常情况下， API 网关要做很多工作，它作为一个系统的后端总入口，承载着所有服务的组合路由转换等工作，除此之外，
- 我们一般也会把安全，限流，缓存，日志，监控，重试，熔断等放到 API 网关来做，那么可以试想在高并发的情况下，这里可能会出现一个性能瓶颈。

API网关选型
私有云开源解决方案：
Netflix Zuul，zuul是spring cloud的一个推荐组件，https://github.com/Netflix/zuul
Kong kong是基于Nginx+Lua进行二次开发的方案， https://konghq.com/
Tyk是2014年创建的开源API网关，甚至比AWS的API网关即服务功能还要早。Tyk用Golang编写并使用Golang自己的HTTP服务器。

公有云解决方案：
Amazon API Gateway，https://aws.amazon.com/cn/api-gateway/
阿里云API网关，https://www.aliyun.com/product/apigateway/
腾讯云API网关， https://cloud.tencent.com/product/apigateway

自开发解决方案
基于Nginx+Lua+ OpenResty的方案，可以看到Kong,orange都是基于这个方案
基于Netty、非阻塞IO模型。 通过网上搜索可以看到国内的宜人贷等一些公司是基于这种方案，是一种成熟的方案。
基于Node.js的方案。 这种方案是应用了Node.js天生的非阻塞的特性。
基于java Servlet的方案。 zuul基于的就是这种方案，这种方案的效率不高，这也是zuul总是被诟病的原因。

## **API工具**

Httpbin.org
请求不同接口，返回不同内容，用于观察客户端情况。

Mockbin.com
自动生成多语言的请求，和临时服务端。

Apipost.cn
Apipost = Postman + Swagger + Mock + Jmeter
API调试功能，使用浏览器可以直接发包测试，使用非常方便，保持请求记录。


参考：
13个用于API设计、开发和测试的免费工具 https://zhuanlan.zhihu.com/p/99494947

## OpenAPI

https://zhuanlan.zhihu.com/p/382164927

OpenAPI 规范 (中文版)
https://openapi.apifox.cn/#schema-%E5%AF%B9%E8%B1%A1

OpenAPI 的授权与认证——swagger2.0的使用
https://blog.csdn.net/weixin_34318956/article/details/91458809

https://www.apifox.cn/?utm_source=Sogou_sem

openapi 好文档
https://swagger.io/docs/specification/authentication/

## OPA

APISIX + Open Policy Agent



# APISIX



## 入门文章

```
模拟这篇文章，体验使用。

# ubuntu 20.04安装 Apache APISIX 
https://www.cnblogs.com/wangguishe/p/16165880.html

发布 API https://apisix.apache.org/zh/docs/apisix/tutorials/expose-api/

# 如何使用 APISIX 进行集中式身份认证 
https://apisix.apache.org/zh/blog/2021/09/07/how-to-use-apisix-auth/

# 网关系统 apisix/kong 日志收集方案实施对比 
https://www.cnblogs.com/zihunqingxin/p/15674011.html

# 发现一个很棒的 单点登录、权限管理的开源方案
https://casbin.cn/
```



## 初始安装脚本

```bash
参考：https://www.cnblogs.com/wangguishe/p/16165880.html
#### 1.安装 etcd

#!/bin/sh
wget https://github.com/etcd-io/etcd/releases/download/v3.5.3/etcd-v3.5.3-linux-amd64.tar.gz
tar -xvf etcd-v3.5.3-linux-amd64.tar.gz
cd etcd-v3.5.3-linux-amd64
sudo cp -a etcd etcdctl /usr/bin/
nohup etcd >/tmp/etcd.log 2>&1 &
etcd --version
etcdctl put name mingming
etcdctl get name

#### 2. 安装apisix 网关
#!/bin/sh
curl https://raw.githubusercontent.com/apache/apisix/master/utils/install-dependencies.sh -sL | bash -
wget https://downloads.apache.org/apisix/2.15.0/apache-apisix-2.15.0-src.tgz
mkdir apisix-2.15.0
tar zxvf apache-apisix-2.15.0-src.tgz -C apisix-2.15.0
cd apisix-2.15.0
LUAROCKS_SERVER=https://luarocks.cn make deps
# 设置代理版本，因为需要github下载很多组件。
# LUAROCKS_SERVER=https://luarocks.cn proxychains make deps
sudo make install
sudo cp  -rf apisix /usr/local/apisix/
sudo cp  -rf deps /usr/local/apisix/

#### 3.初始化
初始化依赖
apisix init
API访问测试
curl -i http://127.0.0.1:9080/apisix/admin/routes?api_key=edd1c9f034335f136f87ad84b625c8f1

#### 参考
vim /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536
```



## API操作

```bash
API Key
cat /usr/local/apisix/conf/config.yaml 
key: edd1c9f034335f136f87ad84b625c8f1
curl -i http://127.0.0.1:9080/apisix/admin/routes?api_key=edd1c9f034335f136f87ad84b625c8f1

# 公开你的服务
https://apisix.apache.org/zh/docs/apisix/tutorials/expose-api/

1.创建上游
curl "http://127.0.0.1:9080/apisix/admin/upstreams/1" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "type": "roundrobin",
  "nodes": {
    "httpbin.org:80": 1
  }
}'

2.创建路由
curl "http://127.0.0.1:9080/apisix/admin/routes/1" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "methods": ["GET"],
  "host": "example.com",
  "uri": "/anything/*",
  "upstream_id": "1"
}'
3. 请求
curl -i -X GET "http://127.0.0.1:9080/anything/get?foo1=bar1&foo2=bar2" -H "Host: example.com"

# 身份认证的玩法
https://apisix.apache.org/zh/blog/2021/09/07/how-to-use-apisix-auth/

1.身份认知插件
curl "http://127.0.0.1:9080/apisix/admin/routes/1" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "methods": ["GET"],
  "uri": "/*",
  "plugins": {
    "basic-auth":{}
  },
  "upstream": {
    "type": "roundrobin",
	"nodes": {
	  "https://httpbin.org": 1
	},
	"pass_host": "pass"
  }
}'

2.配置身份信息
curl "http://127.0.0.1:9080/apisix/admin/consumers" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "username": "foo",
  "plugins": {
    "basic-auth":{
	  "username": "foo",
	  "password": "bar"
	}
  }
}'

3.携带认证信息进行访问​
curl -ufoo:bar http://127.0.0.1:9080/get

# 配置 Authing OIDC
curl "http://127.0.0.1:9080/apisix/admin/routes/1" \
-H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d '
{
  "uri": "/*",
  "plugins": {
    "openid-connect":{
	  "client_id": "6359f9224dc93e2c19f6a0ea",
	  "client_secret": "8c977e7bad348447d02f72484fb1c1f3",
	  "discovery": "https://api6.authing.cn/oidc/.well-known/openid-configuration",
	  "scope": "openid profile",
	  "bearer_only": false,
	  "realm": "master",
	  "introspection_endpoint_auth_method": "client_secret_post",
	  "redirect_uri": "http://47.242.232.158:9080/test"
	},
	"http-logger": {
		"uri": "http://mockbin.org/bin/49b5a098-572c-4f4b-92ad-f9816e58b288"
	}
  },
  "upstream": {
    "type": "roundrobin",
	"nodes": {
	  "httpbin.org": 1
	}
  }
}'
```

