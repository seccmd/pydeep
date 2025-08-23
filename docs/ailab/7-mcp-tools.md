# 7款MCP，改变 写代码方式

> **作者：AI研究生 AI大模型观察站** [**查看原文**](https://mp.weixin.qq.com/s?__biz=MzkzMjkwMjk3Mw%3D%3D\&mid=2247484597\&idx=1\&sn=970d78788d087b4c358c08509d9cfd6a)


最近笔者在用Next.js写一个前端项目项目，半夜 11 点还在手动复制SQL表结构、Google各种JS报错信息。PS：笔者是一个算法+后端工程师，对于前端的框架语法基本上只能靠搜索完成😭。

AI 编程助手不停地吐出过时的 React Hooks 或者是没理解我意思给出我不想要的代码，这让笔者极近崩溃，甚至想把电脑给砸了！！！！！

经过过不断AI工具的尝试，最终笔者发现了 MCP 服务器 —— 这些工具从根本上解决了 AI 编码时的上下文错乱、规划混乱和 UI 丑陋的问题（还的是MCP啊，专业的人干专业的事，在此刻具象化了）。

今天笔者将我用过的7款MCP工具安利给小伙伴们，让大家少走点弯路。

如果喜欢请关注公众号，以后会不断更新内容，和大家一起学习成长~~~

## 1. Context 7 MCP：让你的 AI 永远跟得上最新版文档

有没有遇到过这样的情况？你问 AI 一个新框架的问题，它却给你回复 2019 年的代码。

![](https://mmbiz.qpic.cn/sz_mmbiz_jpg/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7LwgicKgC4aCDvXN0rYdibwnWLY9WDnqDVu005pSseC9SMiaMDpCGDYXjogicA/640?wx_fmt=jpeg\&from=appmsg)

Context 7 MCP 会连接实时文档，让 AI 拥有“最新知识”。

比如你要搭建一个 Next.js 应用，想要设置 App Router。如果没有 Context 7，AI 可能会给你老掉牙的 `getServerSideProps`。但有了它，它会查阅 Next.js 14 的文档，并提供正确代码。

```text
// 老派错误用法export async function getServerSideProps(){...}
// Context 7 的正确用法exportdefaultfunctionProfile(){returnYourProfile;}
```

就像给 AI 打了一针鸡血：速度快、信息准，还节省 token。

适合：经常使用新框架（如 Next.js、SvelteKit）的开发者。

## 2. Supabase MCP：让你远离手写 SQL 的痛苦

写 SQL 或同步 schema 就是一个体力劳动，还容易出错，稍不注意字段名字抄错？类型抄错？字符串长度抄错？在调试的时候才发现问题，到时候整个人都麻了，还要回过头全部检查转换的对不对，非常浪费时间！

![](https://mmbiz.qpic.cn/sz_mmbiz_png/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7LwgFd99ibJ6SmXwMibpKOl6z1dvWhOdiclwwP0LHhryo9Y6LFBmYPnAicyMjQ/640?wx_fmt=png\&from=appmsg)

Supabase MCP 可以把你的 IDE（比如 Cursor）连接到 Supabase 数据库，允许你用自然语言控制它。

比如你可以说：

•“创建一个包含 name 和 email 的 users 表”•“给 posts 表添加 RLS（行级安全）”

它会自动拉取 schema、执行修改，还能保持同步。

```text
--老方法（痛苦）CREATE TABLE users (  id UUID PRIMARY KEY,  email TEXT NOT NULL,  name TEXT);
--Supabase MCP：你说“创建 users 表”，它自动生成 SQL
```

简直就像有个数据库精灵。

适合：不想再为 SQL 烦心的后端开发者。

## 3. Browser MCP：让你的 IDE 内置搜索引擎

调试的时候在浏览器里开 47 个标签页？太常见了。

Browser MCP 让 AI 在 IDE 里“浏览网页”！

你遇到一个奇怪的报错？告诉它搜索日志信息。

需要最新的 Stripe API 文档？它会帮你搜索并总结。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7Lwg1soSBvNUD2sWCSP0hI30EKuPGaib7lne2wVMQia5CVWSm8HUZYccYCCw/640?wx_fmt=png\&from=appmsg)

举个例子：

```text
// 报错：ReferenceError: fetch is not defined你问 AI：“为啥Node.js 的 fetch 会出错？”Browser MCP 查完后告诉你：“Node.js 需要手动引入 fetch，试试这段代码：”import fetch from'node-fetch';
```

就像拥有了一个永不休息的研究助手。

适合：需要调试和查文档的开发者。

## 4. Claude Taskmaster：你的私人项目经理

你有一个超棒的 App 想法，但不知道从哪开始？

![](https://mmbiz.qpic.cn/sz_mmbiz_png/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7LwgagBtzvQPmAtrw66rsAjXC69tP56Vj4iahPcHFMr1WDwbGcaicndmO4jw/640?wx_fmt=png\&from=appmsg)

Claude Taskmaster 可以把你的“想法垃圾堆”变成一个清晰的执行计划。

比如我说：“做一个带登录和暗黑模式的 todo 应用”，它会返回一个有逻辑的任务列表：

```text
1.登录功能：接入Supabase登录，搭个简单界面2.Todo功能：创建数据库表，编写 CRUD 接口3.深色模式：添加主题切换功能，保存用户设置
```

就像有个产品经理一样，而且不会在晚上 9 点给你发 Slack 消息。

适合：身兼数职的个人开发者。

## 5. Exa MCP：杜绝 AI 胡说八道

AI 最令人抓狂的事就是 —— 它编造事实。

Exa MCP 会实时联网查询信息，为 AI 提供真实数据。

![](https://mmbiz.qpic.cn/sz_mmbiz_png/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7Lwg90iafM0d9xy5bZibTNAmCoSLpKtr1QdKf68ibCMbvDUSuznoq17iagbJSA/640?wx_fmt=png\&from=appmsg)

比如你问：

> “Tailwind CSS 每周下载量是多少？”

Exa MCP 会查 npm 或 GitHub，并回答：

> “截至 2025 年 5 月，Tailwind CSS 每周下载量为 1000 万。”

它是 AI 的“真相血清”。

适合：需要查数据、API 或竞品的开发者。

## 6. Knowledge Graph Memory：不用重复造轮子

又要做深色模式了？为什么不复用？

![](https://mmbiz.qpic.cn/sz_mmbiz_png/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7LwgUKeuibaVqSqlvZmgnaBAL40Cc5MoQLGQwCppDibwcibJw35IxCMVxWKoA/640?wx_fmt=png\&from=appmsg)

Knowledge Graph Memory 可以保存你项目的核心逻辑，以便在未来项目中复用。

比如我之前做过一个深色模式，现在只要说“在这个新项目加深色模式”，它就能把之前的逻辑迁移过来。

```text
/* 之前的深色样式 */:root {--bg:#fff;--text:#000;}.dark {--bg:#000;--text:#fff;}
```

简直就是编程界的时间机器。

适合：经常做类似项目的开发者。

## 7. Magic MCP：你身边的免费 UI 设计师

你写的登录按钮看起来像是用 Word 做的？

![](https://mmbiz.qpic.cn/sz_mmbiz_png/6Ex6Atic0gTz2sZU3oeM2sqOoLovh7Lwg8gss0mxksbATwKLkGuwau1iaIIfseManpmqAFJJQESxib4YxsIibDyTsw/640?wx_fmt=png\&from=appmsg)

Magic MCP 可以根据你的提示，生成漂亮的 UI 组件。

比如你说：“做一个现代风格的 Tailwind 登录按钮。”

它就会生成这样的代码：

```text
SignIn
```

UI 看起来就像找了个专业设计师做的。

适合：对设计苦手但想要好看界面的开发者。

## 总结：为什么这些 MCP 工具值得尝试？

这些 MCP 工具，解决了使用 AI 编程时最头疼的问题：

•**上下文错误**：Context 7 MCP、Exa MCP 保证信息新鲜又真实。•**规划混乱**：Claude Taskmaster 自动拆分任务。•**资料缺失**：Browser MCP 秒搜文档。•**界面太丑**：21st Dev Magic 给你“颜值自由”。•**重复造轮子**：Knowledge Graph Memory 让你“写一次用十次”。

挑 1~2 个工具用上，你就像给自己配了个专业 AI 编程助理。

效率翻倍、心情加分，开发体验直接起飞 🚀

具体用法都可以在Github上项目的README中找到，如果有啥问题欢迎留言交流~~~~~~~

![](https://mmbiz.qpic.cn/sz_mmbiz_gif/6Ex6Atic0gTzeibm9CCXcWPWujMu0GVELQr4GKLdtPBEl0L0X8iaQF4oooKwXvpoQewxeJqrjazZ1UP7DuTkHdpVQ/640?wx_fmt=gif\&from=appmsg)
