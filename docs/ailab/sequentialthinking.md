# sequentialthinking 工具使用教程

[GitHub - hailanlan0577/sequential-thinking-tutorial: 关于sequentialthinking工具的中文教程和提示词指南](https://github.com/hailanlan0577/sequential-thinking-tutorial)

[MCP 榜一大哥 SequentialThinking，99%的人都不会用？全网最新实操+认知升级！ - 知乎](https://zhuanlan.zhihu.com/p/1895944861741463294)

[MCP王炸组合，软件开发终极奥义：Sequential Thinking + Software Planning Tool - 掘金](https://juejin.cn/post/7496528481850523683)

[2025最受欢迎的思维神器｜Cursor+Sequential Thinking打造麦肯锡级思维体系](https://mp.weixin.qq.com/s?__biz=MzkzODk3MTIwMQ==\&mid=2247484231\&idx=1\&sn=8a5b979bd251c931f004a7b2192523c6\&chksm=c32bead949608146a03cba4c5b1f77f6d447a84997700ea060e20f27e9374eb16c53ee4e9084#rd)

```Markdown

用sequential-thinking来深入思考一下
检测 39.105.103.147 存活性，和网站是否存在robots.txt


用sequential-thinking来深入思考一下，

使用kali渗透测试，检测 39.105.103.147 的安全性

要求：
- 使用sequential-thinking来规划所有的步骤，思考和分支。
- 全部使用命令行工具，不使用图形界面工具。
- 给出具体安全工具，调用的详细命令和参数。

请验证你的思考过程，并给出最终答案。
```

```Markdown
sequential-thinking工具在处理下一步思考时，会采用 智能上下文筛选 机制，而非简单引入全部历史。具体策略如下：

1. 关键路径优先 ：自动聚焦当前思考分支的主线路径
2. 相关性过滤 ：根据当前思考主题筛选最相关的历史步骤
3. 最近优先 ：优先保留最近3-5个思考步骤的完整上下文
4. 摘要压缩 ：对较早的思考步骤会自动生成摘要而非完整内容
5. 分支隔离 ：不同思考分支的上下文会保持相对独立
这种设计既保证了思考的连贯性，又避免了信息过载。工具会根据当前思考的复杂度和分支情况动态调整上下文引入策略。


要获取sequential-thinking的前一个思考状态，可以通过以下方法：

1. 查看thoughtHistory ：每个思考步骤都会记录在thoughtHistory数组中
2. 使用thoughtNumber ：当前思考步骤编号减1即可定位前一个状态
3. 分支回溯 ：如果有分支思考，可通过branchFromThought字段回溯

打印 thoughtHistory 数组
[
  {
    "thought": "首先需要确定2025年端午节的日期，可以通过以下方法：1. 查询中国农历日历；2. 使用Python的农历计算库；3. 搜索权威的节假日公告。",
    "thoughtNumber": 1,
    "isRevision": false
  },
  {
    "thought": "方法一：查询中国农历日历。端午节是农历五月初五，2025年的农历五月对应的公历日期是6月18日。",
    "thoughtNumber": 2,
    "isRevision": false
  },
  {
    "thought": "方法二：使用Python的lunarcalendar库计算。安装lunarcalendar后，可以准确计算出2025年端午节是公历6月18日。",
    "thoughtNumber": 3,
    "isRevision": false
  },
  {
    "thought": "方法三：搜索中国政府网或国务院发布的节假日安排公告，这是最权威的来源。2025年端午节是6月18日。",
    "thoughtNumber": 4,
    "isRevision": false
  }
]
```

# sequentialthinking 工具使用教程

> 标签: #顺序思维 #sequentialthinking #mcp

## 什么是 sequentialthinking？

sequentialthinking 是一种强大的思考工具，它允许人工智能通过动态和反思性的步骤来解决复杂问题。与简单的问答不同，这个工具通过一系列有序但灵活的思考步骤，逐步深入分析问题，并可以在过程中调整、修正或扩展思路。

## 适用场景

* 需要分步骤解决的复杂问题
* 需要灵活调整的规划和设计
* 可能需要修正方向的分析
* 初始阶段范围不明确的问题
* 需要多步骤解决的问题
* 需要在多个步骤中保持上下文的任务
* 需要过滤无关信息的情况

## 使用方法详解

### 基本参数说明

* **thought**：当前的思考步骤内容
* **next\_thought\_needed**：是否需要继续思考
* **thought\_number**：当前思考的序号
* **total\_thoughts**：预计需要的思考总数
* **is\_revision**：是否修改先前的思考
* **revises\_thought**：如是修改，指出修改哪个思考
* **branch\_from\_thought**：从哪个思考点分支
* **branch\_id**：分支标识符
* **needs\_more\_thoughts**：是否需要更多思考

## 提示词模板与使用流程

### 第一步：提出问题并启动思考工具

```Markdown
请使用sequentialthinking工具帮我解决以下问题：[具体问题]。请从基本分析开始，逐步深入思考。
```

### 第二步：指导工具进行下一步思考（如需要）

```Markdown
请继续思考。我认为你可能需要考虑[某个具体方面]。
```

### 第三步：要求调整思考方向（如需要）

```Markdown
我认为第[X]个思考可能需要修正，因为[原因]。请重新考虑这一点。
```

### 第四步：提出分支思考（如需要）

```Markdown
请从第[X]个思考点创建一个新的思考分支，探索[另一种可能性]。
```

### 第五步：要求总结并给出结论

```Markdown
现在请验证你的思考过程，并给出最终答案。
```

## 实际使用示例

### 示例问题：设计一个高效的远程团队会议系统

**用户**：请使用sequentialthinking工具帮我设计一个高效的远程团队会议系统。请从基本需求分析开始，逐步深入思考。

**Claude 第一次思考**：

```JSON
{
  "thought": "首先需要分析远程团队会议的基本需求。远程会议系统需要解决的核心问题是让分散在不同地点的团队成员能够有效沟通和协作。基本需求包括：视频和音频通话功能、屏幕共享、文件共享、会议记录等。",
  "thought_number": 1,
  "total_thoughts": 5,
  "next_thought_needed": true
}
```

**用户**：请继续思考。

**Claude 第二次思考**：

```JSON
{
  "thought": "接下来需要考虑用户体验设计。系统界面应简洁直观，操作流程应尽可能简化。关键功能如加入会议、打开/关闭麦克风和摄像头、共享屏幕等应该一目了然。还需要考虑不同设备(电脑、手机、平板)的适配，确保跨平台体验一致。",
  "thought_number": 2,
  "total_thoughts": 5,
  "next_thought_needed": true
}
```

**用户**：请继续思考，但我认为我们需要更关注安全性问题。

**Claude 第三次思考**：

```JSON
{
  "thought": "安全性确实是远程会议系统的关键考量。需要实现端到端加密保护会议内容，设置会议密码和等候室功能防止未授权访问，提供会议主持人控制权限如移除参与者、控制屏幕共享权限等。还需考虑数据存储安全和合规性(如GDPR)，防范潜在的"会议轰炸"等安全威胁。",
  "thought_number": 3,
  "total_thoughts": 6,
  "next_thought_needed": true,
  "is_revision": false
}
```

**用户**：我认为第1个思考不够全面，需要更多考虑协作功能。请修正。

**Claude 第四次思考**：

```JSON
{
  "thought": "重新考虑远程会议系统的基本需求，确实需要更强调协作功能。除了之前提到的视频/音频通话、屏幕共享等基础功能外，还应包括：实时协作白板、投票和反馈收集工具、分组讨论室功能、实时文档协作编辑、任务分配和跟踪、会议内即时消息和表情反应等互动功能。这些协作工具能够更好地模拟面对面会议的互动性和高效性。",
  "thought_number": 4,
  "total_thoughts": 6,
  "next_thought_needed": true,
  "is_revision": true,
  "revises_thought": 1
}
```

**用户**：请从第3个思考创建一个分支，考虑如何确保系统的可扩展性。

**Claude 第五次思考**：

```JSON
{
  "thought": "从安全性考虑分支到系统可扩展性。远程会议系统需要能够应对不同规模的会议需求。这包括：采用微服务架构使系统各部分能独立扩展；使用云基础设施实现弹性资源分配，自动根据用户数量调整计算资源；实现负载均衡确保系统在高峰期稳定；考虑全球分布式部署减少延迟；设计API和插件系统允许第三方集成和功能扩展；建立高效的媒体处理和传输机制优化大规模视频会议的性能。",
  "thought_number": 5,
  "total_thoughts": 7,
  "next_thought_needed": true,
  "branch_from_thought": 3,
  "branch_id": "可扩展性分支"
}
```

**用户**：现在请验证你的思考过程，并给出最终答案。

**Claude 最终总结**：

```JSON
{
  "thought": "验证我们的思考过程：(1)修正后的基本需求分析涵盖了核心通讯功能和丰富的协作工具；(2)用户体验设计考虑了简洁性和跨平台适配；(3)安全性分析包含了数据加密、访问控制和合规性；(4)可扩展性分支探讨了系统架构和性能优化。这些思考覆盖了远程会议系统的关键方面。我认为设计方案已经相当完整，可以提出最终建议。",
  "thought_number": 6,
  "total_thoughts": 7,
  "next_thought_needed": false
}
```

**Claude 最终答案**：

基于前面的分析，高效远程团队会议系统的设计应包括四个核心方面：

1. **功能全面性**：不仅提供基础的视频/音频通话和屏幕共享，还应包括实时协作白板、分组讨论室、文档协作编辑、投票工具等协作功能，全方位支持团队互动。
2. **用户体验优先**：界面简洁直观，关键功能易于找到，支持跨平台使用且体验一致，操作流程简化以减少学习成本。
3. **安全与隐私保障**：实现端到端加密，提供会议密码和等候室功能，赋予主持人全面控制权，确保数据存储符合隐私法规。
4. **可扩展性架构**：采用微服务和云基础设施设计，支持从小型会议到大规模会议的弹性扩展，全球分布式部署减少延迟，提供API和插件系统支持功能扩展。

这样的系统设计兼顾了功能性、易用性、安全性和技术可持续性，能够真正提升远程团队的协作效率。

## 使用提示词总结

1. **开始提问**：

```Markdown
请使用sequentialthinking工具帮我解决[问题描述]。请从基础分析开始，逐步深入思考。
```

2. **继续思考**：

```Markdown
请继续思考下一步。
```

3. **引导关注特定方面**：

```Markdown
请继续思考，并特别关注[特定方面]。
```

4. **修正先前思考**：

```Markdown
我认为第[X]个思考需要修正，因为[原因]。请重新考虑这个思考点。
```

5. **创建思考分支**：

```Markdown
请从第[X]个思考创建一个分支，探讨[另一种可能性或方向]。
```

6. **增加思考总数**：

```Markdown
我认为这个问题可能需要更多思考步骤，请增加total_thoughts并继续分析。
```

7. **要求验证和总结**：

```Markdown
请验证你的思考过程，并给出最终答案。
```

通过这套提示词，您可以引导AI使用sequentialthinking工具，逐步深入分析复杂问题，并在需要时调整思考方向，最终得到全面而有深度的答案。

***

## 原始功能说明（英文）

```Markdown
A detailed tool for dynamic and reflective problem-solving through thoughts. 
This tool helps analyze problems through a flexible thinking process that can adapt and evolve. 
Each thought can build on, question, or revise previous insights as understanding deepens.

When to use this tool:
- Breaking down complex problems into steps
- Planning and design with room for revision
- Analysis that might need course correction
- Problems where the full scope might not be clear initially
- Problems that require a multi-step solution
- Tasks that need to maintain context over multiple steps
- Situations where irrelevant information needs to be filtered out

Key features:
- You can adjust total_thoughts up or down as you progress
- You can question or revise previous thoughts
- You can add more thoughts even after reaching what seemed like the end
- You can express uncertainty and explore alternative approaches
- Not every thought needs to build linearly - you can branch or backtrack
- Generates a solution hypothesis
- Verifies the hypothesis based on the Chain of Thought steps
- Repeats the process until satisfied
- Provides a correct answer

Parameters explained:
- thought: Your current thinking step, which can include:
  * Regular analytical steps
  * Revisions of previous thoughts
  * Questions about previous decisions
  * Realizations about needing more analysis
  * Changes in approach
  * Hypothesis generation
  * Hypothesis verification
- next_thought_needed: True if you need more thinking, even if at what seemed like the end
- thought_number: Current number in sequence (can go beyond initial total if needed)
- total_thoughts: Current estimate of thoughts needed (can be adjusted up/down)
- is_revision: A boolean indicating if this thought revises previous thinking
- revises_thought: If is_revision is true, which thought number is being reconsidered
- branch_from_thought: If branching, which thought number is the branching point
- branch_id: Identifier for the current branch (if any)
- needs_more_thoughts: If reaching end but realizing more thoughts needed
```
