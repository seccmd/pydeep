[TOC]

# 技术原理

LDAP AD 是什么？价值作用？操作使用？应用场景？

## 大纲

1.LDAP协议原理
2.LDAP服务（AD、OpenLDAP）
3.LDAP客户端使用（ADExploer、GUI_client?）
4.应用场景（CF、PC、SSO_IdP、???）

## 1.LDAP协议原理

- 什么是 LDAP？https://www.okta.com/identity-101/what-is-ldap/
- LDAP 协议入门 https://zhuanlan.zhihu.com/p/147768058
- LDAP入门 https://www.jianshu.com/p/7e4d99f6baaf
- LDAP概念和原理介绍（应用和目录树属性） https://www.cnblogs.com/wilburxu/p/9174353.html
- LDAP实施实战 https://zhuanlan.zhihu.com/p/33101633
- 企业AD架构规划设计详解 https://cloud.tencent.com/developer/article/1612904
- Active Directory的基本概念 https://www.cnblogs.com/IFire47/p/6672176.html

## 2.LDAP服务

（AD、OpenLDAP）

技术实现：https://ldap3.readthedocs.io/en/latest/welcome.html

1)购买VPS主机 - aliyun win2008

2)安装AD服务

- 多个开源LDAP服务 https://www.oschina.net/project/tag/180/ldap
- 手动搭建AD域: https://help.aliyun.com/document_detail/52565.html

3)管理AD操作

- 手动创建组织单位OU 计算机 用户

4)Ldap查询语法

	该规范定义在RFC 2254 中，详细的介绍请阅读该文档
	ldap查询语法使用前置表达式，每一项的格式为"(propName=propValue)",当然也支持"<,>, =prefix*"
	多个项之间通过"&, |,!"进行组合.
	比如 (&(objectClass=Person)(|(sn=Jensen)(cn=Babs J*)))
	表示查找sn=Jensen或者cn的前缀为Babs J的所有Person 对象
	如果propValue中含有特定的字符，比如'*,\, (,),\0' 需要相应的替换为"\2a,\28,\29,\5c,\00"

## 3.LDAP客户端使用

（ADExploer、GUI_client?）

```
 1）ADSI 管理 从 Windows 开始菜单选择 Windows 管理工具 -> ADSI 编辑器 ，选择菜单 操作 -> 连接到，在弹出的对话框中：
              连接点 -> 选择一个已知命名上下文：配置
              计算机 -> 选择或者键入域或服务器: localhost:389
 2）使用 RSAT: Active Directory 域服务和轻型目录服务工具 安装的 ldp.exe 图形工具，或者 PowerShell 插件
 3）LDAP Admin是一个免费的Windows LDAP客户端管理工具目录管理。
    - http://www.ldapadmin.org/ https://sourceforge.net/projects/ldapadmin/
	- LDAP Admin连接AD域与OpenLdap https://blog.csdn.net/weixin_44728369/article/details/116518293
 4）或者 sysinternals 出品的 AD Explorer
 5）使用 Apache Directory Studio，连接地址为 ldap://...IP...:389，使用 Simple Authentication，Bind DN 为 CN=admin,CN=Users,CN=ad,DC=example,DC=me。
 6）OpenLDAP 图形化管理 https://blog.51cto.com/wzlinux/1837363

```

## 4.应用场景

（CF、PC、SSO_IdP、???）

- 测试CF（站点管理 ——> 用户目录 ——> 添加目录  -->  用户管理）
- keycloak整合LDAP https://blog.csdn.net/qq_36382225/article/details/103974119

```
Microsoft Active Directory
Apache Directory Server 1.0.x
Apache Directory Server 1.5.x
Apple Open Directory (Read-Only)
FedoraDS (Read-Only Posix Schema)
Generic Directory Server
Novell eDirectory Server
OpenDS
OpenLDAP
OpenLDAP (Read-Only Posix Schema)
Generic Posix/RFC2307 Directory (Read-Only)
Sun Directory Server Enterprise Edition
```



## 延申新知识和问题

AD FS是什么 https://zhuanlan.zhihu.com/p/152535932
AD LDS 介绍 https://dieken.gitlab.io/posts/introduction-to-ad-lds/
Wins帮助与支持: https://forsenergy.com/zh-cn/
ApacheDS - LDAP and Kerberos server written in Java - https://directory.apache.org/apacheds/basic-ug/1.1-what-apacheds-is.html
OpenLDAP - LDAP 基础学习笔记（概念 & 快速安装）https://zhuanlan.zhihu.com/p/32732045
除了LDAP之外，JumpCloud还具有云RADIUS，SAML和其他关键IT协议，以及目录集成，以将身份与Active Directory®，G Suite™和Microsoft 365™同步。使用目录即服务，您可以从云中管理用户身份和设备（macOS®、Windows® 和 Linux®），而无需添加本地基础结构。

5)Ldap认证登录原理 Simple Authentication / GSS-API / SASL - Simple Authentication and Security Layer (SASL)

JAAS/GSS-API/SASL/Kerberos简介 https://blog.csdn.net/lijingjingchn/article/details/107177662



# 攻击面

AD安全漏洞和风险？配置漏洞？

组策略，普通域用户，也可以登录AD看到很多信息？ 和管理员区别？
AD技巧之指定用户登录和指定计算机登陆 https://blog.csdn.net/weixin_42351910/article/details/117974303
AD域用户加入本地管理员后限制退域-Win2008/2012 https://www.csdn.net/tags/OtTaYgzsNzY3MzYtYmxvZwO0O0OO0O0O.html

