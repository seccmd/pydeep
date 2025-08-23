[TOC]

# TODO

Todo
- 部署测试krb应用- ad linux
- 攻击面总结
- 教程学习：https://www.jianshu.com/u/23b447f36f98


# Kerberos 大纲
- Kerberos概念原理
- Kerberos功能使用
- Kerberos应用场景
- Kerberos攻击面

# Kerberos概念原理

## Kerberos协议

Kerberos是⼀种认证机制。它的⽬的：通过密钥系统为客户端/服务器应⽤程序提供强⼤的认证服务：保护服务器防⽌错误的⽤户使⽤，同时保护它的⽤户使⽤正确的服务器，即⽀持双向验证；Kerberos协议的整个认证过程实现不依赖于主机操作系统的认证，⽆需基于主机地址的信任，不要求⽹络上所有主机的物理安全，并假定⽹络上传送的数据包可以被任意地读取、修改和插⼊数据。说⽩了， Kerberos通过传统的加密技术（共享密钥）实现了⼀种可信任的第三⽅认证服务。如果把Kerberos中的票据类⽐为⼀张⽕⻋票，那么Client端就是乘客，Server端就是⽕⻋，⽽KDC就是就是⻋站的认证系统。如果Client端的票据是合法的（由你本⼈身份证购买并由你本⼈持有）同时有访问Server端服务的权限（⻋票对应⻋次正确）那么你才能上⻋。当然和⽕⻋票不⼀样的是Kerberos中有存在两张票，⽽⽕⻋票从头到尾只有⼀张。

### 什么是Kerberos 协议

Kerberos 是⼀种基于加密 Ticket (票)的身份认证协议。Kerberos 主要由三个部分组成：Key DistributionCenter (即KDC)、Client 和 Service。

- 客户端会⾸先访问两次KDC，然后再访问⽬标service，如 HTTP服务。
- KDC(Key Distribution Center 密钥分发中⼼)
- KDC是 Kerberos的核⼼组件，主要由三部分组成：
- kerberos Database ：包含了⼀个Realm中所有的 principal(委托⼈)、密码与其他信息。（默认：berkeleyDB）
- Authentication Service（AS）：进⾏⽤户信息认证（确定你是身份证上的本⼈），为客户端提供 TicketGranting Ticket（TGT）。
- Ticket Granting(授予) Service（TGS）：验证TGT与Authenticator
- AD（不属于KDC）：存储所有的 client ⽩名单，只有存储到ad中⽩名单到client才可以申请到 TGT （有些资料⾥没有提及）

### Kerberos 的优势

1. 密码⽆需进⾏⽹络传输。基于 Ticket 实现身份认证，保障密钥安全性。

2. 双向认证。整个认证过程中，不仅需要客户端进⾏认证，待访问的服务也需要进⾏身份认证。

3. ⾼性能。⼀旦Client获得过访问某个Server的Ticket，该Server就能根据这个Ticket实现对Client的验证，⽽⽆须KDC的再次参与。

### 前置知识

1. Kerberos 基于 Ticket 实现身份认证，⽽⾮密码。如果客户端⽆法利⽤本地密钥，解密出 KDC 返回的加密Ticket，认证将⽆法通过。
2. 客户端将依次与 Authentication Service, Ticket Granting Service 以及⽬标Service进⾏交互，共三次交互。
3. 客户端与其他组件交互时，都将获取到两条信息，其中⼀条可以通过本地密钥解密出，另外⼀条将⽆法解密出。
4. （客户端想要访问的）⽬标服务，不会直接与KDC交互，⽽是通过能否正确解密出客户端的请求来进⾏认证。
5. KDC Database 包含有所有 principal 对应的密码。
6. Kerberos 中信息加密⽅式⼀般是对称加密（可配置成⾮对称加密）。

## 客户端访问 http 服务认证过程

### 客户端 与 AS

下⾯，我们将以客户端访问 http 服务为例，学习整个认证过程。

1、客户端 -> AS(Authentication Service

第⼀步，客户端 将 (Client ID、⽤户名，⽬标服务ID，⽹站地址以及其他身份信息)发送给AS。注意不发送密码（hash也不发，⽤hash加密）。

AS -> 客户端

第⼆步，AS检查 客户端ID 是否在 KDC 数据库中。如果在，那么AS会随机⽣成⼀个key，⽤于客户端和 TGS(Ticket Granting Service)之间的 通信。这个Key⼀般称为 TGS session Key 。随后AS会发两条信息给客户端：

1. TGT，由特殊的密钥（TGS的密钥）加密，客户端⽆法解密，包含 客户端ID、TGS Session Key 等信息。

2. 另⼀条信息由客户端密钥加密，客户端可以正常解密，包含HTTP服务ID、TGS Session Key 等信息。

### 客户端 与 TGS

此时，客户端已经有了 TGT （由于本地没有 TGS密钥，所以基本⽆法解出其数据） 与 TGS session key（有的⽂章直接称之为 session key）

1、客户端 -> TGS

1. 客户端，不做任何处理将 AS 发过来的 TGT（由TGS密钥加密的）转发给 TGS。

2. 客户端利⽤ 本地密钥 解密出第⼆条信息。如果本地密钥⽆法解密出信息，那么认证会失败。因为我们需要获得 TGS session key 并利⽤它来加密⼀些客户端信息以及时间戳发送给 TGS。这⼀个数据我们称为Authenticator（身份验证器）

2、 TGS -> 客户端

TGS 将利⽤⾃身的 密钥，从 TGT中解密出 TGS session KEY，然后 利⽤ TGS session Key 从 Authenticator（身份验证器）中解出 客户端的信息。TGS 解密出所有数据后，进⾏身份检查并认证：将客户端ID 与 TGT的客户端ID进⾏⽐较。（判断⽤户是不是被替换了）⽐较来⾃ Authenticator 的时间戳和TGT的时间戳 (典型的Kerberos系统的容忍度是2分钟，但也可以另⾏配置)检查 TGT 是否过期检查Authenticator是否已经在TGS的缓存中（为了避免重放攻击）当所有检查都通过后， TGS 随机⽣成⼀个 Key （相当与有权限访问了）⽤于后续客户端与 HTTP 服务交互时进⾏通信加密使⽤，即 HTTP Session Key。同样地，TGS 将发送两条信息给客户端：（存在疑惑，多个⽂章不⼀致，下⾯为为觉得最靠谱的⼀种）1. ⼀条包含了 HTTP Ticket，由 HTTP 服务的密钥进⾏加密 Ticket=Server Hash(Server SessionKey+Client info+End Time) ；2. 另⼀条则由TGS Session Key加密，包含了 HTTP session KEY。客户端将利⽤TGS Session Key解密出其中⼀条信息，另⼀条信息由于是由⽬标HTTP服务加密，⽆法解密。

### 客户端 与 HTTP service

这时候，客户端有了HTTP Ticket（由于本地没有HTTP服务的密钥，导致⽆法解密出其数据）与 HTTP SessionKey（TGS session 解密得到）。

1、 客户端 -> HTTP Service

1. 将 TGS 发送过来的 HTTP Ticket（由HTTP私钥加密） 转发给 ⽬标 HTTP 服务。

2. 将 包含⾃身信息的 Authenticator（由HTTP Session key 加密） 发送给 HTTP 服务。

2、 HTTP -> 客户端

⾸先 HTTP服务 利⽤⾃身的 密钥解出 HTTP Ticket 的信息，得到 HTTP Session Key后，利⽤HTTP session KEY 解密出 ⽤户的Authenticator信息。解密完成后，HTTP服务做以下信息的检查：将 Authenticator 的时间戳 和 HTTP Ticket 的时间戳 (典型的 Kerberos 系统对差异的容忍度是 2 分钟，但也可以另⾏配置)检查Ticket是否过期检查 Authenticator 是否已经在HTTP服务器的缓存中（为了避免重播攻击）⾄此，所有的认证过程通过，客户端即可与远程HTTP服务完成了身份认证，可以进⾏后续的信息通信。

> KDC（AS TGS）/ Client / Server https://www.kerberos.org/
>
> 一文搞定Kerberos https://zhuanlan.zhihu.com/p/266491528
>
> Kerberos基本概念及原理汇总 https://cloud.tencent.com/developer/article/1381306
>
> Kerberos原理--经典对话 https://cloud.tencent.com/developer/article/1380568?from=10680
>
> 由浅入深理解Kerberos协议 https://mp.weixin.qq.com/s/0CdROpu_AQroqHVg_qZKRQ

# Kerberos基础操作使用

## Kerberos安装

### 第一步：yum 安装 krb 服务

```bash
选择一台机器安装server服务器

yum -y install krb5-libs krb5-workstation krb5-server

集群所有机器安装client客户端

yum -y install krb5-libs krb5-workstation
```

### 第二步：配置 kdc.conf 

默认路径/var/kerberos/krb5kdc/kdc.conf，编辑修改如下：
```
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 HADOOP.COM = {
  #master_key_type = aes256-cts
  max_renewable_life= 7d 0h 0m 0s
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
```

### 第三步：配置 krb5.conf

将krb5.conf同步到集群其他节点。

```
# 默认路径/etc/krb5.conf，编辑修改如下：
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt
 default_realm = HADOOP.COM
#default_ccache_name = KEYRING:persistent:%{uid}

[realms]
HADOOP.COM = {
  kdc = 10.138.93.202
  admin_server = 10.138.93.202
 }

[domain_realm]
.hadoop.com = HADOOP.COM
hadoop.com = HADOOP.COM
```

### 第四步：配置 kadm5.acl

修改服务端的配置文件/var/kerberos/krb5kdc/kadm5.acl，以允许具备匹配条件的admin用户进行远程登录权限：
```
*/admin@HADOOP.COM *

说明：
*/admin代表admin实例的全部用户主体
HADOOP.COM代表领域
最后一个*代表所有权限
这里授权的意思就是admin实例的全部主体拥有HADOOP.COM领域的所有权限
```

### 第五步：创建Kerberos数据库

在服务端对数据库初始化，默认的数据库路径为/var/kerberos/krb5kdc，这里需要设置数据库初始密码，记起来。
```
kdb5_util create -r HADOOP.COM -s

说明：
[-r] 用来指定一个realm_name，当krb5.conf配置了多个realm时使用
[-s] 表示生成 stash file ，并在其中存储master server key（krb5kdc）
创建成功后在/var/kerberos/krb5kdc可以看到生成的相关principal文件
```

### 第六步：启动 Kerberos

```bash
# 启动服务命令
systemctl start krb5kdc
systemctl start kadmin
# 加入开机启动项
systemctl enable krb5kdc
systemctl enable kadmin
服务对应的日志文件（/var/log/krb5kdc.log 和 /var/log/kadmind.log）
```

> REF:
>
> https://mp.weixin.qq.com/s/0ipTZEbhgduZvz-WNByeGg
>
> http://web.mit.edu/kerberos/krb5-1.12/doc/admin/install.html
>
> Kerberos应用 https://www.cnblogs.com/luxianghao/p/5269739.html

## Kerberos操作

### 创建Kerberos管理员：

```
kadmin.local -q "addprinc admin/admin"
# 需要设置两次密码

# kadmin.local需在server端即KDC所在服务器执行

也可以在server端执行kadmin.local命令先登陆kerberos数据库
```

### 创建一个普通用户test：

```
kadmin.local -q "addprinc test"

为test用户生成keytab文件：

#方式1：

kadmin.local -q "xst -norandkey -k /etc/test.keytab test"
#方式2：

kadmin.local -q "ktadd -norandkey -k /etc/test.keytab test"
[-norandkey] 表示创建keytab时，principal的密码不发生改变。如果不使用该参数，直接ktadd -k则会修改principal的密码。
```

### 查看keytab文件：

```
klist -kte /etc/test.keytab
```

### 认证用户：

```
方式1：（服务主体）使用keytab来认证
kinit -kt /etc/test.keytab test

方式2：（用户主体）使用密码来认证
kinit test
```

### 退出当前认证的用户：

```
kdestroy
```

### 查看认证缓存（当前认证的用户）：

```
klist -e
 [-e] 查看当前kerberos账号的加密方式
```

### 查看所有principal主体：

```
kadmin.local -q "list_principals"
也可以用kadmin然后输入admin管理员密码，然后list_principals
```

### 删除principal主体：

```
kadmin.local -q "delete_principal test"
```

> REF:
>
> - Kerberos简介、安装与操作命令 https://mp.weixin.qq.com/s/0ipTZEbhgduZvz-WNByeGg
> - 浅析Kerberos原理，及其应用和管理 https://www.cnblogs.com/luxianghao/p/5269739.html

# Kerberos 应用场景

## AD 应用场景

> Windows下的身份验证----NTLM和Kerberos https://blog.csdn.net/yangxin114/article/details/8112018
>
> AD K https://docs.microsoft.com/en-us/windows-server/security/kerberos/kerberos-authentication-overview
>
> 浅谈NTLM Hash https://www.cnblogs.com/0d4y/p/12805112.html

## Bigdata 应用场景

> 美团点评数据平台Kerberos优化实战 https://mp.weixin.qq.com/s/-K2K22fLOz4Hl7MIUAJfRA
>
> 安装配置Kerberos客户端 https://cloud.tencent.com/developer/article/1380570?from=10680

## SSH-GSSAPI 应用场景

> SSH 默认开启了 GSSAPIAuthentication 认证，http://techpubs.spinlocksolutions.com/dklar/kerberos.html

## PAM 应用场景

> 本指南涵盖可插拔验证模块 (Pluggable Authentication Module, PAM)
>
> https://docs.oracle.com/cd/E56344_01/html/E53971/preface-osmka.html#scrolltoc

# Kerberos攻击面

```
0x01 AS-REQ暴力破解
- 域内用户枚举
- 密码喷洒 Password Spraying
0x02 AS-REP
- Silver ticket
- Golden ticket
0x03 Kerberoasting攻击
0x04 Pass The Hash & Pass The Key
0x05 Pass The Ticket (PTT)
```

### Windows本地认证

0.1 密码在哪里
```
路径： %SystemRoot%\system32\config\sam
```

0.2 密码的形式
```
NTLM Hash后存储在SAM数据库中,当我们登录系统的时候，系统会自动地读取SAM文件中的“密码”与我们输入的“密码”进行对比，如果相同，则认证成功。
> from passlib.hash import nthash
> nthash.hash('admin123')
```

0.3 怎样进行认证

```
- Windows Logon Process(即winlogon.exe) 是负责处理安全相关的用户交互界面的组件。Winlogon的工作包括加载其他用户身份安全组件、提供图形化的登陆界面，以及创建用户会话。

- LSASS(本地安全认证子系统服务)用于微软Windows系统的安全机制。它负责Windows系统安全策略。它负责用户在本地验证或远程登陆时验证用户身份，管理用户密码变更，并产生访问日志。

整体流程如下：
1. 开机
2. winlogon.exe显示输入用户名密码的图形化页面
3. 用户输入用户名密码
4. lssas.exe将密码加密为NTLM Hash，并与本地SAM数据库中的NTLM Hash进行比较
5. 如果相同，则认证通过
```

> 全网最详细的Kerberos协议及其漏洞 https://mp.weixin.qq.com/s/PDhCRD1aOcmtd2wMUrv8Qg
>
> Kerberos 协议相关安全问题分析与利用 https://mp.weixin.qq.com/s/Ic70dj7FSmDHGKTsekjhGQ
>
> Kerberos攻击速查表 https://mp.weixin.qq.com/s/_a9rX1R8EWR-4qCXqlGv4w
>
> Kerberos协议攻击的故事 https://mp.weixin.qq.com/s/IATDJ7n0zRgy5ylIz67VPg