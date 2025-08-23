# IAM+Proxy技术方案

```
Client   -->  Oauth GW Nginx  -->  Service1, Service2, Service3 
                     |                |         |         |
                     |----------------+---------+---------+
                     |
                   IAM
Front   Cas Oauth OIDC  SAML   Basic   
Back    AD LDAP Kerberos 
```

**零信任小demo昨晚跑起来了**

1.访问内网应用WikiJS，首先要通过边界Nginx的代理的访问控制；

2.边界Nginx，需要OAuth登录，才能访问后端服务；

3.边界Nginx，通过IAM身份认证 控制身份准入，隔离了内网服务不直接暴露在外网。

**组件:**

- IAM: Keylocak

- GW : Nginx + OAuth_proxy

- App: WikiJS

**测试操作：**

1.绑定域名 /etc/hosts

  \- <vps_ip> wiki.lab.com

2.访问应用 https://wiki.lab.com/

  \- usertest@lab.com pwd123456

  第一层登录 Nginx 身份认证

  第二层登录 WikiJS 身份认证

  

# 搭建测试环境步骤

**IAM**

```
### IAM
iam.lab.com
访问管理后台,管理员IAM
https://<vps_ip>/admin/master/console/
admin pwd123456
usertest pwd123456
Keycloak OIDC Auth Provider
1.Create new client in your Keycloak realm with Access Type 'confidental', Client protocol 'openid-connect' and Valid Redirect URIs 'https://internal.yourcompany.com/oauth2/callback'
2.Take note of the Secret in the credential tab of the client
3.Create a mapper with Mapper Type 'Group Membership' and Token Claim Name 'groups'.
4.Create a mapper with Mapper Type 'Audience' and Included Client Audience and Included Custom Audience set to your client name.
```

**Oauth proxy**

```
### Oauth proxy
下载 https://github.com/oauth2-proxy/oauth2-proxy/releases
Make sure you set the following to the appropriate url:
./oauth2-proxy \
   --provider=keycloak-oidc \
   --client-id=oauth_proxy \
   --client-secret=g5IfwF4pICSVDyKvkTA4Y8j1iKXcs5VU \
   --redirect-url=https://wiki.lab.com/oauth2/callback \
   --oidc-issuer-url=https://<vps_ip>/realms/master \
   --email-domain=* \
   --upstream=http://127.0.0.1:3000/ \
   --reverse-proxy=true \
   --cookie-secure=true \
   --cookie-secret=mima2233mima2233 \
   --insecure-oidc-allow-unverified-email  
    --allowed-role=<realm role name> // Optional, required realm role
    --allowed-role=<client id>:<client role name> // Optional, required client role
```

**NGINX**

```
### Nginx
server {
    listen 443 default ssl;
    server_name wiki.lab.com;
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/cert.key;
    add_header Strict-Transport-Security max-age=2592000;
    location / {
        proxy_buffer_size 8k;
        proxy_pass http://127.0.0.1:4180;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
        proxy_connect_timeout 1;
        proxy_send_timeout 30;
        proxy_read_timeout 30;
    }
}

### WijiJS
wiki.lab.com
```

ERROR

```
x509: certificate relies on legacy Common Name field
x509: cannot validate certificate for <vps_ip> because it doesn't contain any IP SANs

openssl req -x509 -out lab.crt -keyout lab.key -days 1825 \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=lab.com' -extensions EXT -config <( \
   printf "[dn]\nCN=lab.com\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:lab.com\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

openssl req -x509 -out lab.crt -keyout lab.key -days 1825 \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=lab.com' -extensions EXT -config <( \
   printf "[dn]\nCN=lab.com\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=IP:<vps_ip>\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

x509: certificate signed by unknown authority
将生成的私有证书追加到系统的证书管理文件中，否则后面push和login和pull时会报如下错误：
cp /etc/nginx/lab.crt /usr/local/share/ca-certificates
Ubuntu下添加系统根证书, 只要将证书(扩展名为crt)复制到**/usr/local/share/ca-certificates**文件夹然后运行即可

添加证书：
$sudo update-ca-certificates

删除证书：
$sudo rm -f /usr/local/share/ca-certificates/xinmu.crt  

### 问题，认证成功 报错502，nginx proxy_buffer_size 解决后端服务传输数据过多
502 Bad Gateway after successful login
https://github.com/oauth2-proxy/oauth2-proxy/issues/646
https://blog.csdn.net/Dream_Flying_BJ/article/details/62892870
I changed proxy_buffer_size to 8k(origin 4k) , and 502 is gone.
proxy_buffer_size
```


## **零信任技术选型**

**零信任技术选型：访问代理网关（APISIX）、身份认证（Keycloack）、风控引擎（Drools）。**

零信任安全产品设计实现

​         产品全流程

​             基础方法论（BRD、PRD、产品原型

​             产品 Demo 产品 Team

​                 IAM、Gateway、Risk、Client、Web UI

​                     实时风控引擎(Radar) (riskengine.cn)

**[****[GitHub - authelia/authelia: The Single Sign-On Multi-Factor portal for web apps](https://github.com/authelia/authelia)****](**https://github.com/authelia/authelia**)**

### **oauth2-proxy**

零信任小demo昨晚跑起来了

1.访问内网应用WikiJS，首先要通过边界Nginx的代理的访问控制；

2.边界Nginx，需要OAuth登录，才能访问后端服务；

3.边界Nginx，通过IAM身份认证 控制身份准入，隔离了内网服务不直接暴露在外网。

组件:

IAM: Keylocak

GW : Nginx + OAuth_proxy

App: WikiJS

测试操作：

1.绑定域名 /etc/hosts

  \- <vps_ip> wiki.lab.com

2.访问应用 https://wiki.lab.com/

  \- usertest@lab.com pwd123456

  第一层登录 Nginx 身份认证

  第二层登录 WikiJS 身份认证

![image](581f48e48cb0b2f29e0638dd/cc1b46478367e71a29565559.png)

### Risk

[风控系统资料合集-蚂蚁，京东，美团，开源系统](https://zhuanlan.zhihu.com/p/107975044)

[实时风控引擎(Radar)](https://www.riskengine.cn/)

GW

[如何使用 APISIX 进行集中式身份认证 | Apache APISIX® -- Cloud-Native API Gateway](https://apisix.apache.org/zh/blog/2021/09/07/how-to-use-apisix-auth/)

### **技术问题-https**

https://help.aliyun.com/document_detail/160093.html

HTTPS双向认证（Mutual TLS authentication) (aliyun.com)

https://github.com/smallstep/cli#installation-guide

GitHub - smallstep/cli: 🧰 A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc.

PKI

https://smallstep.com/hello-mtls/doc/client/nodejs

Using Mutual TLS on the Client Side with Node.js — Smallstep

https://smallstep.com/docs/step-ca

step-ca open source server (smallstep.com)

https://github.com/julie-ng/nodejs-certificate-auth

GitHub - julie-ng/nodejs-certificate-auth: Demo for Client Certificate Authentication with Node.js Tutorial
