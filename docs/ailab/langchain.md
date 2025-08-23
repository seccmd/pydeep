# Langchain All

### LangChain 生态重点系统全览

|系统名|核心功能|适用场景|是否开源|
|-|-|-|-|
|**LangChain**|LLM 链式调用/工具集成基座|AI 应用基础开发|✅|
|**LangGraph**|带分支循环的**工作流引擎**|复杂决策系统|✅|
|**LangSmith**|全链路**测试/监控/调试**平台|生产环境部署|免费+付费|
|**LangFlow**|可视化拖拽开发工具|快速原型设计|✅|
|**LangServe**|将 Chain/Graph 部署为 **API 服务**|模型上线部署|✅|
|**LCEL**|链式表达式语言（底层DSL）|高性能链构建|✅|


---

### LangFlow：可视化拖拽构建 LLM 工作流

**定位**：LangChain 的 **低代码/无代码开发环境**

**免费使用**：
👉 [langflow.org](http://langflow.org)

```Markdown
Langflow requires Python 3.10 to 3.13 and uv.

To install Langflow, run:
uv pip install langflow -U

To run Langflow, run:
uv run langflow run

Go to the default Langflow URL at http://127.0.0.1:7860.
```




---

### 🌈 LangFlow：可视化拖拽构建 LLM 工作流  

**定位**：LangChain 的 **低代码/无代码开发环境**  

**核心功能**：  

```Mermaid
graph LR
    A[组件库] --> B[画布拖拽]
    B --> C[节点连线]
    C --> D[实时调试]
    D --> E[导出Python代码]
```

#### 🔧 操作示例（三步建一个问答机器人）：

1. 从左侧组件库拖入：
    - `OpenAI LLM`
    - `PromptTemplate`
    - `OutputParser`
2. 连线构建工作流：

```Markdown
[输入] → [PromptTemplate] → [OpenAI] → [解析] → [输出]
```
3. 一键导出标准 LangChain 代码：  

```Python
from langchain.chains import LLMChain
chain = LLMChain(prompt=prompt, llm=OpenAI()) # 自动生成
```

**免费使用**：
👉 [https://www.langflow.org/](https://www.langflow.org/)  

> 截图示例：
![https://github.com/logspace-ai/langflow/assets/68517091/fc7beae6-6cb6-4f9b-9d8b-5d0f23e1e0a0](https://github.com/logspace-ai/langflow/assets/68517091/fc7beae6-6cb6-4f9b-9d8b-5d0f23e1e0a0)

---

### 🧩 LangChain 生态重点系统全览  

|系统名|核心功能|适用场景|是否开源|
|-|-|-|-|
|**LangChain**|LLM 链式调用/工具集成基座|AI 应用基础开发|✅|
|**LangGraph**|带分支循环的**工作流引擎**|复杂决策系统|✅|
|**LangSmith**|全链路**测试/监控/调试**平台|生产环境部署|免费+付费|
|**LangFlow**|可视化拖拽开发工具|快速原型设计|✅|
|**LangServe**|将 Chain/Graph 部署为 **API 服务**|模型上线部署|✅|
|**LCEL**|链式表达式语言（底层DSL）|高性能链构建|✅|


---

### 🔍 重点系统详解（附代码定位）  

#### 1. **LangServe**（部署利器）  

```Python
from langserve import add_routes
from langchain.chains import LLMMathChain

# 将链转为 REST API
add_routes(app, LLMMathChain(), path="/math-solver")

# 启动服务（支持gRPC/WebSocket）
uvicorn.run(app, port=8080)
```

**功能**：  

- 自动生成 Swagger 文档  
- 内置监控端点 `/health`  
- 支持批处理接口 `/batch`

#### 2. **LCEL**（LangChain表达式语言）  

```Python
# 传统链式写法
chain = prompt | model | output_parser  

# 等效LCEL（支持高级特性）
chain = (
    RunnablePassthrough.assign(x=itemgetter("y")) 
    | prompt.with_config(run_name="格式化提示词")
    | model.with_fallbacks([backup_model])  # 故障转移
    | JsonOutputParser()  # JSON结构化输出
)
```

**优势**：  

- 自带异步/流式支持  
- 超时重试机制  
- 原子化组件复用  

#### 3. **LangChain CLI**（项目管理）  

```Bash
langchain app new my-project  # 创建项目
langchain serve --port 8100  # 本地启动LangServe服务
langchain deploy config.yaml  # 部署到云
```

---

### ⚡ 生态协同实战案例  

**目标**：构建带自动测试的天气查询服务  

```Mermaid
graph LR
    A[LangFlow设计工作流] --> B[导出LangGraph代码]
    B --> C[LangSmith测试分支逻辑]
    C --> D[LangServe部署API]
    D --> E[CLI监控流量]
```

**具体步骤**：  

1. 在 LangFlow 设计天气查询工作流（条件分支 + 天气 API）  
2. 导出为 `weather_graph.py`  
3. 用 LangSmith 创建测试用例：  

```Python
client.create_test(input="上海今天湿度", expected="调用湿度API")
```
4. 通过 LangServe 部署：  

```Python
from langserve import RemoteRunnable
weather_api = RemoteRunnable("http://localhost:8080/weather")
```
5. 使用 CLI 监控：  

```Bash
langchain monitor --endpoint /weather --qps 100
```

---

### 💡 技术选型建议  

|需求类型|推荐方案|优势点|
|-|-|-|
|**快速验证想法**|LangFlow + LCEL|1小时产出MVP|
|**企业级复杂系统**|LangGraph + LangSmith|可靠性+可观测性|
|**内部工具部署**|LangServe 本地部署|免运维|
|**生产环境服务**|LangServe + 云平台|弹性扩缩容|


所有工具链文档直达 👉 [https://python.langchain.com/docs/ecosystem/](https://python.langchain.com/docs/ecosystem/)

