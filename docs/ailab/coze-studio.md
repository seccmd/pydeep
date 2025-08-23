# Coze Studio

文章：

- [https://www.cnblogs.com/xiaoqi/p/19005840/coze](https://www.cnblogs.com/xiaoqi/p/19005840/coze)


```markdown
今天看到很多人都在说 Coze 开源了，我原本以为开源的只是 Coze 的开发工具、组件之类，看了说明发现不是这么简单，而是差不多把完整的 Coze 和背后 Prompt 的开发工具都开源出来了。所以今天花了不少时间在本地运行，看源代码，认真学习了 Coze 的两个新开源项目：Coze Studio（扣子开发平台） 和 Coze Loop（扣子罗盘）

Coze Studio 差不多是完整的 Coze，工作流、Agent 这些功能都相当完整，接上 API Key 就能跑起来了。 它的核心模块包括：
工作流（Workflow）引擎： 拖拽加上少量设置就可以完成工作流的建设，用起来很丝滑
插件（Plugin）的框架：Coze 开源了插件的定义、调用和管理机制，有官方开源插件作为示例，可以比较容易的创建和集成第三方API

Coze Loop 则是一个面向开发者的工具，你可以方便的调试、优化 Prompt、监控线上 Prompt 的运行，借助工具，让 Prompt 的效果不再是玄学，而是可以通过数据来量化。

这两个项目的开源协议都是 Apache 2.0 许可证，说明你是可以商用不需要授权的，可以根据需要进行二次开发，很适合个人或者企业使用，你可以方便的在自己的环境中搭建一套使用。🧵
```

这次开源了 Coze 的两个核心组件：

1. **Coze Studio** - 整个平台的核心，提供可视化界面，让用户通过简单的拖拽操作就能创建复杂的 AI 工作流
2. **Coze Loop** - AI 智能体的调试工具和管理平台，涵盖从提示词工程到性能监控的全生命周期管理

开源协议方面都采用了极其宽松的 **Apache 2.0 开源协议**，意味着任何人都可以免费使用、修改，甚至用于商业化部署。

### 系统要求

- 最低配置：2C4G
- 必备软件：Docker、Docker Compose

```markdown
# 1. clone 源代码
git clone https://github.com/coze-dev/coze-studio.git

# 2. 进入项目目录
cd coze-studio

# 3. 复制模型配置模板
cp backend/conf/model/template/model_template_ark_doubao-seed-1.6.yaml backend/conf/model/ark_doubao-seed-1.6.yaml

# 4. 配置模型参数
# 编辑 backend/conf/model/ark_doubao-seed-1.6.yaml 文件
# 设置模型ID、API密钥等参数

# 5. 启动服务
cd docker
cp .env.example .env
docker compose --profile '*' up -d

# 部署完成后，打开 http://localhost:8888/ 就可以开始使用了。
```
