# TODO

阿里云最佳实践 https://help.aliyun.com/document_detail/138811.html 

[单点登录协议有哪些？CAS、OAuth、OIDC、SAML有何异同？](https://cloud.tencent.com/developer/article/1727265) 

https://cloud.tencent.com/developer/article/1727265 

[认证和授权中不得不提及的 OAuth、SSO、CAS、JWT - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/437812127) 

分布式身份认证——未来信任生态的基石 https://zhuanlan.zhihu.com/p/80919000

# 系统层面-身份认证基础

**基于口令的身份认证技术**

基于口令的身份认证技术一般包括账户名和密码，用户通过固定的用户名确认身份信息，通过密码验证是否是本人，这也是我们日常接触最多的身份认证系统。

**挑战/ 响应认证机制**

即认证服务器端向客户端发送不同的挑战码，客户端程序收到挑战码后，根据客户端和服务器之间共享的密钥信息以及服务器端发送的挑战码，做出相应应答。服务器根据应答的结果确定是否接受客户端的身份声明。

**基于DCE/Kerberos 的认证机制**

Kerberos 是为解决分布式网络认证而设计的可信第三方认证协议。它可用来为网络上的各种server提供认证服务，使口令不再以明文方式在网络传输，并且联接之间通讯是加密的。Kerberos的认证系统基于私钥体制(对称密码体制)，该认证过程的实现不依赖于主机操作系统的认证，无需基于主机地址的信任，不要求网络上所有主机的物理安全，并假定网络上传送的数据包可以被任意地读取、修改和插入数据。

由于Kerberos 身份认证采用的是对称加密机制，加解密都需要相同的密钥，交换密钥时的安全性不能保障。此外，在Kerberos中，客户信息和服务器认证信息都集中存放在AS 服务器中，其安全性严重依赖于AS 和TGS 的性能和安全。

**基于公共密钥的认证机制**

基于公共密钥的安全策略进行身份认证，即使用符合X.509 协议的身份证明。须有一个第三方的证明授拟中心为客户签发身份证明。客户和服务器信任该证明授权中心，并各自获取证明，在会话和通讯时首先交换身份证明，其中包含了将各自的公钥交给对方，然后才使用对方的公钥验证对方的数字签名、交换通讯的加密密钥等。在确定是否接受对方的身份证明时，还需检查有关服务器，以确认该证明是否有效。



# 应用层面-身份验证基础

## 身份验证的本质

身份验证的存在意义是什么？为了对某些有安全性需求的特定资源进行控制，只让某些特定的主体（个人、公司、甚至是一段代码）对其执行某些特定的操作（查看、修改等）。为此，对于想要访问资源的主体，需要按照顺序达成如下两个条件：

1. 认证（Authentication）：知道 ta 究竟是谁
2. 授权（Authorization）：知道 ta 有没有权限对资源执行试图执行的操作

### 认证

认证是决定一个主体（之后统称「用户」）究竟是谁的过程，换句话来说，是将「当前意图访问资源的用户」和「提前存储好的身份信息」对应起来的过程。显然，这个操作需要由身份信息的持有者来完成，我们称其为「IdP（Identity Provider）」，它存储的身份信息列表称为「用户目录」或「用户池」。

所谓的「身份信息」可以是任意格式，包含但不限于以下两种内容：用户的唯一标识符（可以是唯一的用户名、随机字符串、UUID 等），以及只有该用户才能提供，用来确认该用户身份的私密信息（密码、指纹等）。前者可以是公开的，但后者必须是私密的，只有 IdP 和用户自身才能持有。

为了完成认证，用户必须首先「宣称」自己是谁，并且这个宣称需要以某种形式和用户目录中的唯一一条记录产生关联。显然，最简单的办法就是直接向 IdP 宣布自己的唯一标识符。之后，用户需要通过某种保密的途径悄悄告诉 IdP 自己的私密信息，IdP 确认无误后，就可以证实「宣称」的有效性，然后将当前正在进行请求的用户和用户目录中的身份信息对应起来。如此一来，用户在 IdP 上的认证过程就完成了。

### 授权

确认了用户的身份之后，下一步就是确认用户到底有没有权限访问想要访问的资源了。拥有身份信息后，这一步就变得很简单了——只需根据对应资源的权限设置，检查用户的对应操作是否被允许即可。授权操作可以，但未必由 IdP 来执行，这一点会在后面详细解释。



## 身份和资源的分离

在最简单的身份模型中，身份持有者（IdP）和资源持有者运行在同一个上下文中。这意味着一旦 IdP 完成了某个用户的认证，资源持有者立刻就能知道（例如通过数据库查询）用户的身份信息。之后用户访问资源时，资源持有者就能利用这一信息来决定是否允许用户的操作（相当于自己执行授权），或者把这一决定交给 IdP 来做（相当于 IdP 执行授权）。

这种模型的缺点显而易见——每个应用都要维护一套自己的用户目录，不同应用之间无法共享身份信息。为了解决这个问题，一个自然的想法就是将 IdP 独立出来，让所有资源持有者都从 IdP 处获取用户的身份。这种做法存在一个前提条件：当一个用户在 IdP 上完成了认证之后，资源持有者必须得知这一点，并能从 IdP 处获取用户对应的身份信息，而且这一渠道必须是可信的，身份信息不能被恶意篡改。在实际应用中，资源持有者一般会在用户访问资源时，向 IdP 获取用户的认证状态和身份信息。如果成功，之后的授权步骤就和上面一致了。

独立的 IdP 有一个天然的好处——只要用户在 IdP 上进行过了认证，其下关联的所有资源持有者都能获取到用户的身份信息，正所谓「一次认证，到处访问」。所谓的「单点登录（SSO）」本质上就是如此。

由于 Web 应用天生的无状态性，资源持有者并不能确定访问资源的用户和在 IdP 上认证过的用户是同一个，因此用户每次访问资源时都需要提供身份标识符和密码，由资源持有者向 IdP 进行确认。为了解决这一问题，IdP 在完成认证时可以向用户颁发一个临时的「令牌（Token）」，这个 Token 存储着用户目录中的用户身份，只有用户本人才能持有，并且经过 IdP 的数字签名。用户访问资源时，通过 Cookie 等手段自动向持有者提供 Token，持有者可以在本地利用签名验证 Token 的真实性和有效性，并且从 Token 中获取到用户的身份信息，无需再经过 IdP 了。为了防止 Token 从用户处泄露，它只在短时间内有效，失效后必须由 IdP 重新颁发。最著名的 Token 技术是「JWT（Json Web Token）」，它也是 OIDC 协议（之后会解释）的一部分。除此之外，SAML 协议中的「断言（Assertion）」也可以起到和 Token 相同的作用。

当然，用户的登录态也可以由资源提供者来维护，资源提供者在向 IdP 确认用户身份后自己向用户颁发一个类似的 Token，存放在用户 Cookie 中。此时的 Token 可以实际存储身份信息并进行签名，也可以作为一个索引的 Key，指向存放在资源提供者后端的，从 IdP 处获得的身份信息（也就是所谓的 Session）。

值得注意的是，在分离模型中，如果授权步骤由 IdP 执行，用户在 IdP 上进行授权时还需要提供自己想要访问的资源种类和执行的操作，IdP 签发 Token 时也需要将这些信息写在 Token 中，以便资源持有者核验。「资源」和「操作」的二元组被称为「Scope」，OIDC 登录时传人的其中一个参数就是它。



## 由用户决定的授权（OIDC 协议）

之前的讨论中存在一个隐含的假设——资源的所有权并不在用户手中，而是在外部的管理者手中，因此用户访问资源时才需要首先获取权限。然而在当今的互联网中，很大一部分信息都是用户产生的，用户理应拥有自己资源的完全控制权限。在这种场景之下，「授权」的概念依旧存在，只不过被授权的主体不再是用户，而是「想要访问用户资源的第三者」，而颁发权限的主体也不再是管理员，而是用户自己。此时，这个「第三者」被称为「SP（Service Provider）」，也称为「Client」，而用户资源的存放处依然称为「资源提供者」。由于以下的讨论仅涉及授权而不涉及认证，为了方便起见，不妨假设本章节中「资源提供者」和「IdP」运行在同一上下文中，统称「IdP」，同时负责认证用户身份和提供资源。

举个例子，用户想在自己的微信中看到自己 Github 账号的状态，在这种情况下，微信是 SP ，Github 是 IdP，微信需要访问用户存储在 Github 下的资源（账号状态）。由于微信和 Github 是两个互相不信任的应用，也因为用户有权控制其在 Github 下的资源，Github 不能在未取得用户许可的情况下，向微信提供任何用户资源。因此，微信首先需要指引用户前往 Github 进行认证和授权，这通常是用重定向用户浏览器来实现。Github 会首先进行认证操作，确认用户的身份（显然只有用户本人才有权向第三者提供他的资源的访问权限）。身份验证通过后，Github 还会根据管理员配置的权限列表，确认用户本身拥有微信所请求资源的对应访问权限（因为请求的资源也可能不完全属于用户）。这一点也确认无误后，Github 就会弹出授权确认页面，向用户确认「是否授予微信对应权限」。用户确认完成后，Github 就会签发一个 Token，由用户转交给微信，微信方只需向 Github 提供这个 Token 就可以访问之前请求的资源了。

作为标准身份协议之一的 OIDC 正是为此种场景而生。OIDC 的认证和授权分为四种模式（事实上，这四种模式是作为 OIDC 前身的 OAuth 协议定义的）：

- 授权码模式（Code）
- 隐式模式（Implicit）
- 密码模式（Password）
- 客户端证书模式（Client Credential）

### 授权码模式

授权码模式是最为规范的模式。它的主要步骤如下：

1. SP 将客户端重定向到 IdP 的 OIDC 授权地址，附上自己请求的权限（Scope）和一个回调地址
2. IdP 在自己的页面上完成认证，并由用户确认权限
3. IdP 通过客户端向 SP 的回调地址发送一个授权码（Code）
4. SP 的后端向 IdP 的另一个接口发出含有 Code 的请求，得到 IdP 颁发的 Token

授权码模式的优点在于 Token 不由用户，而是由 SP 持有，降低了意外泄露带来的风险。值得注意的是，用户在 IdP 上进行认证和授权的过程是 IdP 自行规定的，和 OIDC 协议无关。在 OIDC 协议中，IdP 颁发的 Token 是 JWT。

### 隐式模式

隐式模式可以看作省略了 Code 的授权码模式。它的主要步骤如下：

1. SP 将客户端重定向到 IdP 的 OIDC 授权地址，附上自己请求的权限（Scope）和一个回调地址
2. IdP 在自己的页面上完成认证，并由用户确认权限
3. IdP 通过客户端向 SP 的回调地址直接发送 Token

可以看到，此时的 Token 经过了用户的客户端，容易被中间人窃取。由于访问用户资源的是 SP 而不是用户本人，只让 SP 持有 Token 永远是更为正确的选择。

### 密码模式

密码模式在隐式模式的基础上进一步省略了 IdP 上的授权过程。它的主要步骤如下：

1. SP 在自己的页面上请求用户输入在 IdP 上的用户名和密码
2. SP 向 IdP 的 OIDC 授权地址发起请求，附上用户输入的帐密
3. IdP 确认帐密的正确性，然后在响应中直接发送 Token

密码模式只应用在 IdP 和 SP 互相信任，或者 SP 由用户本人控制（例如移动端或桌面应用）的情况下，因为用户的帐密经过了 SP，只要 SP 愿意，完全可以通过用户的帐密在 IdP 上无限制访问用户的全部资源。也正因如此，密码模式中让用户确认权限是没有意义的，SP 获取的一定是用户资源的完全访问权限。

### 客户端证书模式

客户端证书模式和用户无关，只用于在 IdP 上授权特定 SP 访问特定资源。它的主要步骤如下：

1. SP 提前在 IdP 上注册一个证书（一般是账号 + 密码）
2. SP 向 IdP 的 OIDC 授权地址发起请求，附上自己的证书
3. IdP 确认证书的正确性，然后在响应中直接发送 Token

显然，客户端证书模式也只应用于 IdP 和 SP 互相信任，或是 SP 只访问用户无关资源的情况下。由于没有征得用户的同意，如非必要，IdP 不应授权 SP 访问用户的私密信息。

## 标准身份协议

除了 OIDC 协议之外，还存在着许多标准身份协议，例如 SAML 和 CAS。它们的存在意义都是类似的：为了能让素不相识的 SP 和 IdP 进行快速对接，在用户的许可下让 SP 在 IdP 处完成授权，从而访问 IdP 下资源提供者的资源。

SAML 协议和 OIDC 的隐式模式类似。发起 SAML 请求的 SP 会将客户端重定向到 IdP 的 SAML 端点，附上一段 base64 编码的 xml 格式信息，包含 SP 自身信息和本次操作的信息。IdP 验证 xml 后，同样会在自己页面进行认证和用户授权，随后向 xml 中包含的回调地址发送另一段经过签名的 xml，包含用户的身份信息。这段 xml 称为「SAML 断言」。SP 接收到断言后，就可以利用断言去资源提供者处请求数据了。

CAS 协议类似 OIDC 的授权码模式，它的授权码称为「Ticket」。它和 OIDC 唯一的不同点在于 SP 用 TIcket 换到的是一段 xml 格式的身份信息，并且没有经过签名，因此 CAS IdP 和资源提供者必须通过其他可信渠道进行用户认证信息的传递（当然也可以运行在同一上下文），不能仅通过 SP 提供的用户身份信息来信任 SP。

事实上，如果实际需求只是让用户在 IdP 处进行验证和授权，并访问本 IdP 下资源提供者的资源，而不涉及第三方应用，也可以使用标准协议。此时用户和 SP 是同一概念，Token 由用户自身持有。但是不难发现，这种情况下，标准协议不仅没有任何优势，反而增加了适配协议的复杂性——原本事情只要 IdP 提供一个登录页面，给用户一个 Token 就解决了！如果一定要使用标准协议，应当选择尽可能靠近原始登录流程的协议，例如 OIDC 的密码模式。

## 联邦认证

之前的讨论中，我们假设所有的认证过程都只利用 IdP 自身存储的身份信息来完成。事实上，IdP 还可以把认证过程委托给其它的 IdP，此时委托方 IdP 对于被委托 IdP 而言相当于一个 SP，从被委托 IdP 处获取认证成功后返回的身份信息，然后重新扮演 IdP 的角色，利用该信息完成用户在自身上的认证。当然，委托方 IdP 还可以把身份信息复制到自己的用户目录内，创建一个新账户，之后的认证就无需经过第三方 IdP 了。这种场景就是「联邦认证」。既然联邦认证本质上也是 IdP 和 SP 之间的交互，那么使用标准身份协议无疑是最快捷的方式。

举个例子，微信中「使用 Github 登录」的按钮就是一个联邦认证的实例。当用户点击这个按钮后，微信会作为 SP，利用标准身份协议向作为 IdP 的 Github 发起认证和授权请求，回调地址则是微信内部的地址。用户在 Github 的页面上进行认证，并授权微信访问自己的用户信息（用户信息也是资源的一种，所以 IdP 本身就是一个资源提供者）后，Github 就会向微信发送 Token。随后微信用 Token 向 Github 请求用户身份信息，在自己的用户目录中查找是否存在已有的匹配关系。这种关联一般是二元组的形式，第一元作为查找的 Key，是某种在 Github 中唯一且固定不变的身份标识符（例如 openid 或 unionid），第二元是微信中的唯一身份信息 ID。如果找到关联，用户在微信中的身份信息就确定了；如果找不到，可以利用用户在 Github 中的身份信息，在微信的用户目录中新建一个身份条目和对应的关联二元组，并视情况要求用户确认、修改或补全部分身份信息。不论哪种情况，微信最终都能得到用户在自身用户目录中的身份信息，换句话说就是完成了认证。

在联邦认证中，一个重要的问题是如何将位于两个不同身份源，但表示同一用户的信息进行匹配。可以用在两个 IdP 中相对唯一的信息，例如手机号或邮箱进行匹配。这一匹配过程不能覆盖委托方 IdP 中原有的身份信息，否则就会出现以下安全问题：假设外部（被委托） IdP 中的身份信息会覆盖内部（委托方） IdP 中相同邮箱的信息，那么一旦有人故意在外部 IdP 中注册一个内部 IdP 中已有的邮箱，他就可以直接利用联邦认证去登录内部 IdP 中同一邮箱的账户，哪怕这个账户原本不属于他！理论上来说，在从外部 IdP 导入身份信息（也就是用户第一次通过该身份源登录）时，将其与任意一条已有的内部身份信息对应都是不安全的。这些身份信息应当永远关联一个新创建的内部账户，然后，如果该用户的身份信息能匹配到内部 IdP 中已存在的一个账户，首先进行额外的认证过程，确认他确实拥有这个账户，然后才能建立新的关联。无论哪种情况，已经建立的关联都不应被修改，哪怕用户在外部身份源修改了身份信息，他在内部 IdP 对应的身份信息 ID 也不应改变（当然，内部身份信息的某些字段在不产生冲突的前提下，还是可以根据外部身份信息进行适当同步的）。在关联建立之后，用户再通过该身份源登录时，就可以直接利用这个关联查到用户在内部 IdP 中的身份信息了。



# Server 身份认证技术实现

## PAM

本章介绍可插拔验证模块 (Pluggable Authentication Module, PAM)。PAM 提供了一个框架，用于插入对 Oracle Solaris OS 上的应用程序用户的检查。PAM 提供了一个管理应用程序使用的中央框架，包括对用户进行验证、管理口令更改、关闭和打开用户会话以及跟踪帐户限制（例如每日时间段限制）。PAM 可扩展到第三方应用程序，因此能够对系统服务访问提供无缝管理。

## SAML

## SASL

简单验证和安全层 (Simple Authentication and Security Layer, SASL)





# Web 身份认证技术实现

## CAS

Casdoor https://github.com/casdoor/casdoor

## OAuth

OAuth 2.0 Simplified https://www.oauth.com/

OAuth 官网 https://oauth.net/2/

OAuth 2.0 扩展协议之 PKCE https://www.cnblogs.com/myshowtime/p/15555538.html

## OIDC

## SAML

## JWT

## FIDO

华为线上快速身份验证服务（ FIDO2 ）
https://developer.huawei.com/consumer/cn/codelab/HMSCoreFIDO2/index.html#0
线上快速身份验证服务
https://developer.huawei.com/consumer/cn/codelab/HMSCoreFIDOBioAuthn/index.html#6

https://fidoalliance.org/fido2/
https://blog.csdn.net/zdc280399854/article/details/78733735
https://open.bccastle.com/guide/admin/auth_source/fido2.html
https://www.freebuf.com/articles/system/247237.html
https://www.zhihu.com/question/28233883
https://www.beyondidentity.com/glossary/fido2
https://www.sohu.com/a/279984779_490113
https://yubikey.cn/topics/2
https://www.w3.org/TR/webauthn/

# Oauth/OIDC 技术原理

## 技术原理入门

```
10 分钟理解什么是 OpenID Connect（OIDC） 协议 https://deepzz.com/post/what-is-oidc-protocol.html
10 分钟理解什么是 OAuth 2.0 协议 https://deepzz.com/post/what-is-oauth2-protocol.html
OAuth 2 Simplified https://blog.csdn.net/weixin_39741101/article/details/111677657
OAuth 2 Simplified https://aaronparecki.com/oauth-2-simplified/
The OAuth 2.0 Authorization Framework: Bearer Token Usage https://datatracker.ietf.org/doc/html/rfc6750
The OAuth 2.0 Authorization Framework https://datatracker.ietf.org/doc/html/rfc6749
OAuth2.0和OIDC详解 https://www.jianshu.com/p/4400a44535a1
OAuth及OIDC技术分享PPT杂记 https://blog.csdn.net/luo15242208310/article/details/123596841
```

## OAuth 在线工具

```
# OAuth 在线工具
https://www.oauth.com/oauth2-servers/tools-and-libraries/

# 非常好的模拟器
https://www.oauth.com/playground/
# OAuth Example-app
https://example-app.com/client
# Base64 Decode
https://example-app.com/base64.php
# OpenID Connect debugger
https://oidcdebugger.com/

# JWT.IO allows you to decode, verify and generate JWT.
https://jwt.io/

# OAuth 比较清晰的流程图
https://blog.seriesci.com/how-to-mock-oauth-in-go/
```

## 协议攻击面

```
https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html

https://apisecurity.io/issue-136-oauth-2-0-security-checklist-pentesting/

https://0xn3va.gitbook.io/cheat-sheets/web-application/oauth-2.0-vulnerabilities

https://portswigger.net/web-security/all-labs
https://portswigger.net/web-security/oauth
https://portswigger.net/web-security/oauth/openid
https://portswigger.net/web-security/oauth/preventing
https://infosecwriteups.com/oauth-2-0-hacking-simplified-part-2-vulnerabilities-and-mitigation-d01dd6d5fa2c

https://github.com/koenbuyens/oauth-2.0-security-cheat-sheet
https://github.com/koenbuyens/Vulnerable-OAuth-2.0-Applications

/20151215-Top_X_OAuth_2_Hacks-asanso.pdf
```



# WikiJSAuth

| Name                            | DESC                                                         |
| ------------------------------- | ------------------------------------------------------------ |
| CAS                             | The Central Authentication Service (CAS) is a single sign-on protocol for the web. |
| Keycloak                        | Keycloak is an open source software product to allow single sign-on with Identity Management and Access Management aimed at modern applications and services. |
| LDAP / Active Directory         | Active Directory is a directory service that Microsoft developed for the Windows domain networks. |
| Azure Active Directory          | Azure Active Directory (Azure AD) is Microsoft’s multi-tenant, cloud-based directory, and identity management service that combines core directory services, application access management, and identity protection into a single solution. |
| Generic OAuth2                  | OAuth 2.0 is the industry-standard protocol for authorization. |
| Generic OpenID Connect / OAuth2 | OpenID Connect 1.0 is a simple identity layer on top of the OAuth 2.0 protocol. |
| SAML 2.0                        | Security Assertion Markup Language 2.0 (SAML 2.0) is a version of the SAML standard for exchanging authentication and authorization data between security domains. |
| Okta                            | Okta provide secure identity management and single sign-on to any application. |
| Auth0                           | Auth0 provides universal identity platform for web, mobile, IoT, and internal applications. |
|                                 |                                                              |
| Slack                           | Slack is a cloud-based set of proprietary team collaboration tools and services. |
| Discord                         | Discord is a proprietary freeware VoIP application designed for gaming communities, that specializes in text, video and audio communication between users in a chat channel. |
| Dropbox                         | Dropbox is a file hosting service that offers cloud storage, file synchronization, personal cloud, and client software. |
| Facebook                        | Facebook is an online social media and social networking service company. |
| Firebase                        | Firebase is Google's mobile platform that helps you quickly develop high-quality apps and grow your business. |
| GitHub                          | GitHub Inc. is a web-based hosting service for version control using Git. |
| GitLab                          | GitLab is a web-based DevOps lifecycle tool that provides a Git-repository manager providing wiki, issue-tracking and CI/CD pipeline features. |
| Google                          | Google specializes in Internet-related services and products, which include online advertising technologies, search engine, cloud computing, software, and hardware. |
| Microsoft                       | Microsoft is a software company, best known for it's Windows, Office, Azure, Xbox and Surface products. |


