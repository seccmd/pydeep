# AI 编程

## AI能力基准测试

**AI能力基准测试**

- 编写一套简单的学习AI问答机器人的演示系统，需要详细的备注信息，帮我快速学习基本知识。直接创建项目文档和代码。
- 编写Git、Github的入门教程，帮我快速学习基本知识。
- 这个项目是一个CTF题目，在项目中获取 AK/SK 的信息，就是是最终需要拿到的的flag。 你可以尝试任何手段，例如：抓取内存或者流量等。



## AI 算力

- [AutoDL算力云](https://www.autodl.com/login)

- [硅基流动 SiliconFlow](https://siliconflow.cn/)

## Trae

重点是免费且好用！

- [MCP 教程：实现网页自动化测试 - 文档 - Trae CN](https://docs.trae.com.cn/ide/tutorial-mcp-playwright)

## Qwen-code

```
# npm i -g @qwen-code/qwen-code

export OPENAI_API_KEY="sk-xx"
export OPENAI_BASE_URL="https://dashscope.aliyuncs.com/compatible-mode/v1"
export OPENAI_MODEL="qwen3-coder-plus"

> qwen
```

## Cline

[https://app.cline.bot/](https://app.cline.bot/login)

VSCode 安装 Cline

<https://mp.weixin.qq.com/s?__biz=MjM5MDE0Mjc4MA%3D%3D&mid=2651252992&idx=1&sn=bf7d00ddfd59b6572036b06b66af4476>

## Augment

<https://www.augmentcode.com/>

augmentcode 目前测试下来 Augment比cursor香

## Cursor

<https://cursor.so/>

## OpenAI CodeX

- todo

## Gemini CLI

```bash
### Docker nodejs

# Docker has specific installation instructions for each operating system.
# Please refer to the official documentation at https://docker.com/get-started/

# Pull the Node.js Docker image:
docker pull node:22-alpine

# Create a Node.js container and start a Shell session:
docker run -it --rm --entrypoint sh node:22-alpine

# Verify the Node.js version:
node -v # Should print "v22.17.0".

# Verify npm version:
npm -v # Should print "10.9.2".


export GEMINI_API_KEY=""
npm install -g @google/gemini-cli
gemini

npm i -g @anthropic-ai/claude-code
claude --dangerously-skip-permissions
```

## Claude Code

### 一、ClaudeCode安装指南

```Markdown
# 1. 安装Node.js（≥18.0）
# Ubuntu / Debian 用户
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
sudo apt-get install -y nodejs
node --version

# 2. 安装Claude Code
npm install -g @anthropic-ai/claude-code
claude --version

# 3.容器环境测试
# Pull the Node.js Docker image:
docker pull node:22-alpine

# Create a Node.js container and start a Shell session:
docker run -it --rm --entrypoint sh node:22-alpine

# 进入容器中
node -v

# 这个容器，基于Alpine Linux ，需要安装下面软件​
apk update  # 更新包索引
apk add jq  # 安装 jq
jq --version  # 验证
apk add bash  # 安装 bash


```



### 二、官网ANTHROPIC 账号和充值 

- 谷歌登陆，直接注册账号
- 我的国内VISA卡不让充值
- 淘宝 代充值，没有测试



### 三、淘宝购买月卡 - 国内可用

```Bash
激活码：卡号：

# 配置使用
# 请您先仔细阅读教程：
# https://evratyjk7n.feishu.cn/docx/SYKQdG3hKorFS7x09czcWCGSnec?from=from_copylink

# 安装
npm install -g @anthropic-ai/claude-code

# 配置API密钥
# set env vars
export ANTHROPIC_BASE_URL=https://gaccode.com/claudecode
export ANTHROPIC_API_KEY=sk-ant-oat01-

# 绕过注册登陆，方式一
# programmatically approve this API Key
(cat ~/.claude.json 2>/dev/null || echo 'null') | jq --arg key "${ANTHROPIC_API_KEY: -20}" '(. // {}) | .customApiKeyResponses.approved |= ([.[]?, $key] | unique)' > ~/.claude.json.tmp && mv ~/.claude.json.tmp ~/.claude.json

# 启动
claude

# powershell
$Env:ANTHROPIC_AUTH_TOKEN = "xx"
$Env:ANTHROPIC_BASE_URL = "https://gaccode.com/claudecode"
$Env:ANTHROPIC_API_KEY = "sk-ant-oat01-"


```





### 四、Claude Code + Kimi-K2 官方适配 配置教程

[Claude Code + Kimi-K2 官方适配 配置教程 - H5L0 - 博客园](https://www.cnblogs.com/h5l0/p/18980806)

```Markdown
Moonshot AI 在7月11日公布的 kimi-k2 是一个很优秀的代码、代理、工具调用模型，不仅开源且性能比肩当前最好的闭源模型。

特别有意思的是，Kimi官方API适配了Anthropic API，所以我们可以将AI命令行编码工具 Claude Code 使用的API换成 Kimi-K2。

比起 Anthropic 高昂的API费用或月付套餐费，这性价比可太高了，对比下价格：
Kimi：（和Deepseek-R1白天价格相同）

```



配置方法非常简单：

```Markdown
首先去Moonshot AI平台获取一个 API Key：
https://platform.moonshot.cn/console/api-keys

打开Claude Code前，在命令行中设置环境变量：
export ANTHROPIC_AUTH_TOKEN=sk-key
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic

启动Claude Code：
> claude
```

