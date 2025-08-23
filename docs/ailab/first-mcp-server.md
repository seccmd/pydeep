# 开发第一个MCP Server

> **作者：AI取经路** [**查看原文**](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ%3D%3D\&mid=2649038855\&idx=1\&sn=941028c77cb1632fb52909e76287a6cd)


本文提供了一个完整的**MCP Server 实现示例**，通过 Python 代码和Cline测试，展示了 MCP 如何用于**增强 AI 应用的能力**，特别是**Tool 能力的集成和调用**。

* 1. 常见AI应用对MCP Server能力的支持情况
* 2. 代码实现MCP Server
* 2.1 配置环境
* 2.2 新建MCP Server : hello\_mcp\_server.py
* 3. 使用Cline测试Server
* 3.1 Cline连接MCP Server的相关源码

\--领取学习资料大礼包，见文末

在[《一文说清楚让LangChain大佬“开战”的MCP是什么？》](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038667\&idx=1\&sn=d1467904da2f8acc62b7bb4838737ed2\&scene=21#wechat_redirect)中详细的介绍了MCP.

MCP为连接**AI应用**与数据源提供了一个通用的开放标准，用单一协议取代了碎片化的集成。通过这个机制， 能力小的**AI应用**会变成更强的应用

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybMKLre9NTvIQYlUw1lc0hVWAcQ8icgboib0BaKWWaPpUPEjFOH7S8Oftw/640?wx_fmt=png\&from=appmsg)

在整个MCP的架构中，我们的**AI应用**（如Cline）作为MCP Hosts，通过内部的MCP Client去接入不同的MCP Server，从而达到增强能力的目的

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybaTB3Zd25QM2UfyN1Wk3u7pPibZWnwR8FjZqRXicNuHMcD6Fm8yNytKFA/640?wx_fmt=png\&from=appmsg)

根据MCP协议，当**AI应用**连接到MCP Server后，能够获取多种能力，比如Tool，Prompts、Resources等

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybUnX88IU5WcdYqLh2rcQnnoPqj8w1IcBfhrTsgiaIPJBpCsYfVFMu6rw/640?wx_fmt=png\&from=appmsg)

详细内容见：[一文说清楚让LangChain大佬“开战”的MCP是什么？](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038667\&idx=1\&sn=d1467904da2f8acc62b7bb4838737ed2\&scene=21#wechat_redirect)

## 1. 常见AI应用对MCP Server能力的支持情况

目前MCP还在发展过程中，我们可以通过官方看到常见**AI应用**目前可以使用的能力情况。

应用对于Tool能力的使用，目前是最广泛的：

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybYf4ziaNL3zmIdMEqsUTIIjPBWaUhKUKPa5InAdeQ10StsibuskLzZmKQ/640?wx_fmt=png\&from=appmsg)

## 2. 代码实现MCP Server

我们要实现一个简单的server，他将有一个tool，可以通过订单号查询物流信息。

这个server在整个架构中的位置，就是下图中绿色的块：

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybDPreWrahvLcoTHrEzmNxHQBvgSUibp7sKy1ncVO4qjvH1Y1IX3vlD6w/640?wx_fmt=png\&from=appmsg)

### 2.1 配置环境

首先，让我们安装 `uv` 并设置我们的 Python 项目和环境：

**安装uv工具（windows）**

```text
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**重新开启一个终端，并确认uv已经安装成功**

```text
PS G:\workspace\idea\py\hello-mcp-server> uv version
uv 0.6.6 (c1a0bb85e 2025-03-12)
```

> ❝ 在macos/linux环境中安装uv

```text
curl -LsSf https://astral.sh/uv/install.sh | sh
```

> ❝ uv是一个用 Rust 编写的极快的 Python 包和项目管理器。 官网：<https://github.com/astral-sh/uv>

**创建项目，初始化环境：**

```text
`# 初始化项目 uv init hello-mcp-server # 创建Python虚拟环境 cd hello-mcp-server uv venv # 激活虚拟环境 .venv\Scripts\activate # 安装依赖 uv add mcp[cli]` 
```

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybdRkcicJkPua6OyPLRwb79WcVSibZqCJT0C49DrCHtvo1yfUTACorWd4Q/640?wx_fmt=png\&from=appmsg)

### 2.2  新建MCP Server : `hello_mcp_server.py`

我们新建一个Server，并增加tool来模拟通过订单号查询物流信息的功能

#### 2.2.1 定义一个server

导入包并定义mcp实例

```text
"""
pip install mcp[cli]
"""
from mcp.server.fastmcp import FastMCP
from pydantic import Field

# Initialize FastMCP server
mcp = FastMCP("hello-mcp-server", log_level="ERROR")
```

#### 2.2.2 定义工具

通过`@mcp.tool()`注解，把一个函数注册为Tool

```text
# 注册工具的装饰器，可以很方便的把一个函数注册为工具
@mcp.tool()
asyncdef query_logistics(order_id: str = Field(description="订单号")) -> str:
    """查询物流信息。当用户需要根据订单号查询物流信息时，调用此工具
    
    Args:
        order_id: 订单号
    
    Returns:
        物流信息的字符串描述
    """
    # 统一的物流信息数据
    tracking_info = [
        {"time": "2024-01-20 10:00:00", "status": "包裹已揽收", "location": "深圳转运中心"},
        {"time": "2024-01-20 15:30:00", "status": "运输中", "location": "深圳市"},
        {"time": "2024-01-21 09:00:00", "status": "到达目的地", "location": "北京市"},
        {"time": "2024-01-21 14:00:00", "status": "派送中", "location": "北京市朝阳区"},
        {"time": "2024-01-21 16:30:00", "status": "已签收", "location": "北京市朝阳区三里屯"}
    ]

    # 格式化物流信息
    result = f"物流单号：{order_id}\n\n物流轨迹：\n"
    for item in tracking_info:
        result += f"[{item['time']}] {item['status']} - {item['location']}\n"

    return result
```

#### 2.2.3 使用 MCP Inspector 进行测试

MCP Inspector 是一个用于测试和调试 MCP 服务器的交互式开发工具。

<https://modelcontextprotocol.io/docs/tools/inspector>

**启动MCP Inspector：**

执行命令：`mcp dev hello_mcp_server.py`

```text
(hello-mcp-server) PS G:\workspace\idea\py\hello-mcp-server> mcp dev hello_mcp_server.py
Starting MCP inspector...
Proxy server listening on port 3000

🔍 MCP Inspector is up and running at http://localhost:5173 🚀
```

通过浏览器打开<http://localhost:5173>

**连接MCP Server:**

点击“Connect”启动MCP Server并建立连接

1.使用标准输入输出作为传输层

2.使用命令是uv

3.uv命令的参数

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybCVSGnxEmYrcbUpGQerNPjvicP1rbXdZJK6XHR8DQhjAPl5N40ev0GgQ/640?wx_fmt=png\&from=appmsg)

**查询所有的Tool：**

1.点击“Tools”能力标签

2.点击“List Tools”，查询server中所有的tool（调用了协议的`tools/list` 端点）

3.显示出所有的tool

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybLJVvZxcgMG4iaM6TDZXaTpEByFSFTOdSStlHJJL7IcNdId8xJx246iaQ/640?wx_fmt=png\&from=appmsg)

**执行Tool：**

1.选择需要测试的tool

2.输入入参：ORDER-123456，点击“Run Tool”（调用了协议的`tools/call` 端点）

3.Tool成功返回结果

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybib5fgzBlWxxtTjwDbZRqKnPD1G4TAo4JrHHyTylRnehokfKBrmwC8AQ/640?wx_fmt=png\&from=appmsg)

## 3. 使用Cline测试Server

打开Cline，点击上边的“MCP Server”

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybQ42ugOBC7WCIwrAOq9e7e1uIRe1CGeibKY3icicDtvJHCC5KNspHThq2A/640?wx_fmt=png\&from=appmsg)

选择“Installed”

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybicdYZEsViaibPxIDR14Nt7v4MBKsFxzGQQyfa8ibstnd1kmY6xnu0IDslA/640?wx_fmt=png\&from=appmsg)

点击“Configure MCP Servers”

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybMibxs7r0pw2xX6KpvBCQXhxIibibMHdOk7uYB2Cib11iaFyYoR8sxsNZJjw/640?wx_fmt=png\&from=appmsg)

右边会弹出配置文件

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybMmjEypWIG2d5Lf8MMm8Fyr0rDgctZM2FO1icCyiafsvFqfyPUUEEFFgg/640?wx_fmt=png\&from=appmsg)

将自己刚写的服务器相关配置填进去，保存

```text
"hello-mcp-server": {
"name": "第一个MCP服务",
"key": "hello-mcp-server",
"command": "uv",       
"args": [
    "--directory",
    "G:\\workspace\\idea\\py\\hello-mcp-server\\",
    "run",
    "--with",
    "mcp",
    "mcp",
    "run",
    "hello_mcp_server.py"
  ],
"disabled": false,
"autoApprove": []
}
```

**整个完整命令相当于：**

```text
uv --directory G:\workspace\idea\py\hello-mcp-server\ run --with mcp mcp run hello_mcp_server.py
```

分为3段：

1. `uv --directory G:\workspace\idea\py\hello-mcp-server\` 指定工作目录
2. `run --with mcp` 运行时必须要有mcp包被安装
3. `mcp run hello_mcp_server.py` 使用mcp启动server

左边会生成对应的服务列表，点击“Done”退出

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybq87x7c4ANPFAQQZo9RwBLnUjGBNhNTt6yQOj0FXX9CR1JyBLSnc6AA/640?wx_fmt=png\&from=appmsg)

在Cline对话框中输入提示词：查一下订单为“ORDER-123456”的物流信息

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybPRibREKgV2CG8AdbMjuee8UypzdK46aBCQrbXv6Xy4L4z5ztJDVm20w/640?wx_fmt=png\&from=appmsg)

Cline开始调用MCP Server，点击“Approve”同意

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vybSzicJic7SxytdicSp7OJwh4hHuTKtEVLYED85yp9GkWJ1slS9FP1R1Jfw/640?wx_fmt=png\&from=appmsg)

MCP Server调用成功

![\<span leaf="">\<br>\</span>](https://mmbiz.qpic.cn/mmbiz_png/ko3ibXTD3NELmMxVONY7HGo0kYdPe6vyb7kEsfRyGegYmPV4ymIMcbuhPF5TNcvDx3010SHc9w0qtUP9HV07dxg/640?wx_fmt=png\&from=appmsg)

### 3.1 Cline连接MCP Server的相关Client源码

Cline(相当于MCP架构中的Host)源码中，MCP相关的代码在`src/services/mcp/McpHub.ts`中，MCP Clinet连接MCP  Server的代码在`connectToServer`:

```text
private async connectToServer(name: string, config: StdioServerParameters): Promise<void> {
  ...

try {
   // 创建新的MCP客户端实例，设置客户端名称和版本信息
   const client = new Client(
    {
     name: "Cline",
     version: this.providerRef.deref()?.context.extension?.packageJSON?.version ?? "1.0.0",
    },
    {
     capabilities: {},        // 客户端没有给服务端暴露能力
    },
   )

   // 创建标准输入输出传输实例，配置命令、参数和环境变量
   // 这个是我们配置文件的内容
   const transport = new StdioClientTransport({
    command: config.command,
    args: config.args,
    env: {
     ...config.env,
     ...(process.env.PATH ? { PATH: process.env.PATH } : {}),
    },
    stderr: "pipe", 
   })

            ......
            
   // 启动传输层，建立实际的进程间通信通道
   await transport.start()
   
   ...

   // 建立MCP客户端连接
   // 连接成功后更新服务器状态为已连接，清除错误信息
   // 初始化并获取服务器提供的工具和资源列表
   await client.connect(transport)
   connection.server.status = "connected"
   connection.server.error = ""

   // 初始化获取工具资源列表
   connection.server.tools = awaitthis.fetchToolsList(name)
   connection.server.resources = awaitthis.fetchResourcesList(name)
   connection.server.resourceTemplates = awaitthis.fetchResourceTemplatesList(name)
  } catch (error) {
   ......
  }
 }
```

到目前为止我们实现了一个能提供Tool能力的MCP Server

往日推荐：

1. [从源码看OpenManus：如何用开源技术复刻Manus](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038516\&idx=1\&sn=172254bf26b3f7ff23f853f480e87a5e\&scene=21#wechat_redirect)
2. [LangChain实战 | 路由机制让AI助手更聪明，专业问题交给专业模块！](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038248\&idx=1\&sn=fb46934ddd6c12b261a4dcd23fb503ab\&scene=21#wechat_redirect)
3. [以前做PPT要3天，现在只要10分钟！DeepSeek+Kimi 让我效率起飞！](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038160\&idx=1\&sn=2c5087f3f823097352483e86a54be59b\&scene=21#wechat_redirect)
4. [LangChain实战 | MultiQueryRetriever 让 RAG 更懂你的问题](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038076\&idx=1\&sn=c876b11f688e1efa065c80fe53b9807d\&scene=21#wechat_redirect)
5. [北京大学发布《DeepSeek提示词工程与落地场景》技术文档，推动国产AI应用创新](https://mp.weixin.qq.com/s?__biz=MzI4MjE1Nzc2MQ==\&mid=2649038009\&idx=1\&sn=ef85b93bec5d908b2b436b316f19a986\&scene=21#wechat_redirect)

![](https://mmbiz.qpic.cn/mmbiz_jpg/ko3ibXTD3NELPrDo2pTRDCrjba7NoOSElQlJzumtya910soFutD2XGib3oSicr70TziazoNq96bcEHNud8aJjVYcrw/640?wx_fmt=jpeg\&from=appmsg)

有需要的，在公众号「**AI取经路**」发消息「学习资料」即可获取。

**--END--**

点亮 **“赞”**和**“在看”**，\*\*“分享”\*\*好友一起看
