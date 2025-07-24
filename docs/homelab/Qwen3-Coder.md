# Qwen3-Coder开源：面向世界的智能编程引擎

> **作者：阿里云**
[**查看原文**](https://mp.weixin.qq.com/s?__biz=MzA4NjI4MzM4MQ%3D%3D&mid=2660253383&idx=1&sn=1e6554ca14538133e2c462a9c538b0d0)

刚刚，通义千问最新的AI编程大模型Qwen3-Coder正式开源。

全新的Qwen3-Coder模型拥有卓越的代码和Agent能力，在Agentic Coding、Agentic Browser-Use 和 Foundational Coding Tasks 上均取得了开源模型的 SOTA 效果。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PWfGo6nyrZicBIOofeFjaY7NIVrpuBI9Bhalec0nt4UxmOZVKibuRjdPw/640?wx_fmt=jpeg&from=appmsg)

Qwen3-Coder 拥有多个尺寸，今天率先开源当前最强大版本：Qwen3-Coder-480B-A35B-Instruct 模型。它是一个MoE模型，拥有 480B 参数，激活 35B 参数，原生支持 256K 上下文，并可通过 YaRN 扩展到 1M 长度。

为方便开发者更好地使用 Qwen3-Coder，通义团队还开源了一款命令行工具 Qwen Code，可充分发挥 Qwen3-Coder 在代理式编程上的潜力。此外， Qwen3-Coder 的 API 也可以和 Claude Code、Cline 等工具协同使用。

目前，Qwen3-Coder 已在魔搭社区、HuggingFace 等平台开源，全球开发者都可以免费下载使用。Qwen3-Coder 很快将接入阿里的AI编程产品通义灵码，API也已上线阿里云百炼。

- *魔搭社区：*[*https://modelscope.cn/models/Qwen/Qwen3-Coder-480B-A35B-Instruct*](https://modelscope.cn/models/Qwen/Qwen3-Coder-480B-A35B-Instruct)
- *Hugging Face：*[*https://huggingface.co/Qwen/Qwen3-235B-A22B-Instruct-2507*](https://huggingface.co/Qwen/Qwen3-235B-A22B-Instruct-2507)
- *Qwen Code GitHub：*[*https://github.com/QwenLM/qwen-code*](https://github.com/QwenLM/qwen-code)

***# Qwen-Coder技术亮点***

***// 预训练***

通义团队在预训练阶段上仍然在努力，这次 Qwen3-Coder 从不同角度进行 Scaling，以提升模型的代码能力：

- 数据扩展：总计 7.5T（代码占比 70%），在保持通用与数学能力的同时，具备卓越的编程能力；
- 上下文扩展：原生支持 256K 上下文，借助 YaRN 可拓展至 1M，专为仓库级和动态数据（如 Pull Request）优化，助力 Agentic Coding；
- 合成数据扩展：利用 Qwen2.5-Coder 对低质数据进行清洗与重写，显著提升整体数据质量。

***// 后训练***

![](https://mmbiz.qpic.cn/sz_mmbiz_png/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5P5GoIezibFPUe5DQ6jsjK9wtSI7gn5KM8QfRB2RmdLIfr94sRDXRTosg/640?wx_fmt=png&from=appmsg)

与当前社区普遍聚焦于竞赛类代码生成不同，通义团队认为所有的代码任务天然适合执行驱动的大规模强化学习。因此通义团队选择在更丰富的真实代码任务上扩展 Code RL 训练。

通过自动扩展测试样例，通义团队构造了大量高质量的训练实例，成功释放了强化学习的潜力：不仅显著提升了代码执行成功率，还对其他任务带来增益。这将鼓励通义团队继续寻找 Hard to Solve, Easy to Verify 的任务，作为强化学习的土壤。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PEE3BUoAJvWNaEgiaQ6jX2AjjLLibYcgx4ibJX5J7nDEThicZRUDvKQcRow/640?wx_fmt=jpeg&from=appmsg)

在真实世界的 Software Engneering Task，比如 SWE-Bench，模型需要在环境中不断交互，自主规划、选择工具调用、接受反馈不断做出新决策，这是一个典型的 Long-Horizon RL 任务。

通义团队在 Qwen3-Coder 的后训练阶段执行了 Agent RL，鼓励模型通过多轮交互的方式利用工具解决问题。Agent RL 的主要挑战在于 Environment Scaling，通义团队实现了可验证环境的扩展系统，借助阿里云的基础设施，实现同时运行 20k 独立环境。

这一套基础设施可以提供大规模的强化学习反馈和评测，最终通义团队在 SWE-bench Verified 上实现了开源模型 SOTA 的效果。

***# 和Qwen3-Coder一起Coding***

Qwen3-Coder 可以和社区优秀的编程工具结合，如 Claude Code、Cline 等，作为一款基础模型，我们期待在数字世界的任何角落都可以使用它，Agentic Coding in the World!

**// Qwen Coder**

Qwen Code 是一个 CLI 工具，修改自 Gemini CLI，针对 Qwen3‑Coder系列的模型增强了解析器和工具支持。

确保已安装 Node.js 20 及以上版本，可以通过以下命令安装：

```text
curl -qL https://www.npmjs.com/install.sh | sh
```

然后通过 npm 管理器安装 Qwen Code：

```text
npm i -g @qwen-code/qwen-code
```

另一种方式是从源码安装：

```text
 `git clone https://github.com/QwenLM/qwen-code.git` 
 `cd qwen-code && npm install && npm install -g`
```

Qwen Code 支持 OpenAI SDK 调用 LLM，你可以导出以下环境变量，或者简单地将其放在 .envfile中。

```text
export OPENAI_API_KEY="your_api_key_here"
export OPENAI_BASE_URL="https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
export OPENAI_MODEL="qwen3-coder-plus"
```

现在，你可以通过简单地输入 「qwen」来享受 Qwen-Code 和 Qwen 带来的编程体验。

***// Claude Code***

除了 Qwen Code 之外，现在还可以将 Qwen3‑Coder 与 Claude Code 搭配使用。只需在阿里云百炼平台[https://bailian.console.aliyun.com/申请](https://bailian.console.aliyun.com/申请) API Key，并安装 Claude Code，即可开始畅享编码体验。

```text
npm install -g @anthropic-ai/claude-code
```

通义团队提供了两种接入方式，帮助你无缝地用 Qwen3‑Coder 进行编码。

**方案一：使用dashscope提供的代理  API**

只需要将Anthropic的base url替换成dashscope上提供的endpoint即可。

```text
export ANTHROPIC_BASE_URL=https://dashscope-intl.aliyuncs.com/api/v2/apps/claude-code-proxy
export ANTHROPIC_AUTH_TOKEN=your-dashscope-apikey
```

**方案二：使用 claude-code-config 自定义路由**

claude-code-router 是一个第三方的路由工具，用于为 Claude Code 灵活地切换不同的后端 API。dashScope平台提供了一个简单的扩展包 claude-code-config，可为 claude-code-router 生成包含 dashScope 支持的默认配置。

```text
npm install -g @musistudio/claude-code-router
npm install -g @dashscope-js/claude-code-config
```

生成配置文件和插件目录：

```text
ccr-dashscope
```

该命令会自动生成 ccr 所需的配置文件和插件目录。你也可以手动调整 ~/.claude-code-router/config.json 和 ~/.claude-code-router/plugins/ 中的配置。

最后，通过 ccr 开始使用 Claude Code：

```text
ccr code
```

至此，你即可通过 ccr 使用 Claude Code 畅享 Qwen3‑Coder 的强大编码能力。祝开发顺利！

***// Cline***

![](http://mmbiz.qpic.cn/sz_mmbiz_jpg/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5Pa27nZiaiamib7mnbq5hcMgYH35oc4XIibTOiaic0hRdQd1uot73IafYhUXbA/0?wx_fmt=jpeg)

配置 Qwen3-Coder-480B-A35B-instruct 以使用 cline：

‒ 进入 cline 的配置设置

‒ 选择“OpenAI Compatible”模式

‒ 在 OpenAI Compatible API tokens处，输入从 Dashscope 获取的密钥

‒ 勾选“使用自定义基础 URL”，并输入：[https://dashscope.aliyuncs.com/compatible-mode/v1](https://dashscope.aliyuncs.com/compatible-mode/v1)

‒ 输入模型名称：qwen3-coder-plus

***# Demo展示***

以下是使用Qwen3-Coder制作的动画与小游戏。

*Demo：烟囱拆迁*

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PDSW568d38zeRUbmQ7wCOutOicKvhILMKG3X0lTZNHIf01Gm0ib0wW2oA/640?wx_fmt=gif&from=appmsg)

*Demo：本地开发端中生成烟花动画*

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PGa1DHNicxlic62X63V03k76Xs57Xiad49L9MwMgribibibQTVTOtGTtaEdeg/640?wx_fmt=gif&from=appmsg)

*Demo：打字测速演示*

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PgGmuVQc1XdhGOVYFIxKczfseyqic2nw2Sg39ty7k8VgQlgiaibgg3zljA/640?wx_fmt=gif&from=appmsg)

*Demo：小球沿立方体轨迹旋转*

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PYxcZoIlemj4P4VdEgXKtRSZkDItSOYtNErzfkfWnWj3F9fVxiav1CTg/640?wx_fmt=gif&from=appmsg)

*Demo：模拟太阳系行星运转*

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PPeXiaFu9UOOZlF0OTSN1lUvp37hpfxyCqrKjd6icN5wEna7q8nuN7gMA/640?wx_fmt=gif&from=appmsg)

*Demo：二重奏游戏*

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/V3ll7FMyGyOkHSjHFm3iaMicPhH73JIY5PnY86JWpF8hDPhYtX1SvDic88dU57ajACtpFWiaJrXwVZNYOiciaPhNVowg/640?wx_fmt=gif&from=appmsg)

***# API调用***

如果你想要通过百炼 API 平台（[https://bailian.console.aliyun.com/）调用](https://bailian.console.aliyun.com/）调用) Qwen3-Coder，欢迎使用以下示例代码进行测试。

```text
import osfrom openai import OpenAI
client = OpenAI(    api_key=os.getenv("DASHSCOPE_API_KEY"),    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",)
prompt = "Help me create a web page for an online bookstore."

# Send request to qwen3-coder-plus modelcompletion = client.chat.completions.create(    model="qwen3-coder-plus",    messages=[        {"role": "system", "content": "You are a helpful assistant."},        {"role": "user", "content": prompt}    ],)
# Print the responseprint(completion.choices[0].message.content.strip())
```

***# 未来展望***

通义团队仍在继续努力提升 Coding Agent 的效果，希望它能承担更多复杂软件工程中的繁琐任务，解放人类的生产力。Qwen3-Coder 仍有更多尺寸在路上，在保证良好效果的同时降低部署的开销。另外通义团队也在积极探索 Coding Agent 是否能够实现 self-improving，这是一个令人激动的话题。

/ END /

*更多Qwen模型一手资讯，请关注👇👇👇*
