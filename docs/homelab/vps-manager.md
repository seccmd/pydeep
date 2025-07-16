# 服务器管理工具

Runtipi是一个功能强大且易于使用的开源项目，无论是对于家庭服务器管理还是在线编程与学习等方面都具有广泛的应用前景。

**| 主要功能**

* 一键安装与更新：Runtipi提供了超过200种受欢迎应用程序的一键安装和更新功能，无需配置Docker知识。用户可以从Runtipi的应用商店中选择任何应用程序，并进行预配置安装，所有内容均可根据用户需求进行自定义。
* SSL证书管理：Runtipi支持自动SSL证书管理，通过Let's Encrypt即时向外界展示应用程序。
* 多语言支持：作为IDE，Runtipi支持多种编程语言，如Python、Java、JavaScript等，通过后端灵活的编译与执行策略实现。
* 实时编译与执行：利用WebSockets实现代码编辑器与服务器间的数据同步，确保代码更新即时生效。编辑器下方的终端会立即显示程序运行结果，帮助快速调试。
* 沙箱环境：Runtipi在安全的隔离环境中运行用户代码，保证系统的稳定性和安全性。
* 协作与分享：支持共享代码链接，实时查看并讨论他人更改，简化团队合作。可保存代码到本地或生成共享链接，便于回顾和交流。
* 跨平台：由于其Web基础，Runtipi在任何支持浏览器的设备上都可使用。

**| 使用范围**

* 家庭媒体中心：使用Runtipi部署Plex或Jellyfin，轻松管理家庭媒体库。
* 私有云存储：通过部署Nextcloud，实现文件的私有云存储和同步。
* 智能家居中心：集成Home Assistant，管理智能家居设备。
* 在线编程与学习：对于教育者，Runtipi是演示代码示例的理想工具；对于学生，可以随时随地练习编程，无需安装本地环境。开发者可以在Runtipi中快速创建代码片段，测试新想法，或者进行简单的任务处理。
* 在线面试：HR和技术人员可以通过Runtipi进行实时编程面试，观察候选人解决问题的能力。

**如需了解更多信息，可以访问其官方网站或查阅相关的技术文档。**

> 官方网站 <https://runtipi.io/>

> GitHub地址 <https://github.com/runtipi/runtipi>

**安装&使用**

**—******—****———**—**

操作系统为腾讯云服务器Ubuntu，安装步骤是通过指令形式一键安装。

**| 安装**

```text
curl -L https://setup.runtipi.io | bash
```

或者直接从github下载脚本

```text
curl -L https://raw.githubusercontent.com/runtipi/runtipi/master/scripts/install.sh | bash
```
