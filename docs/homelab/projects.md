# 项目目录分类管理规范​

以下是为项目目录分类管理设计的**简洁清晰的模板**，专为高效管理与快速回顾而优化。结合最佳实践与工程化规范，涵盖分类策略、目录结构、工具链与维护要点，帮助您系统化组织学习实验、开源测试与正式项目。

---

### 🗂️ **项目目录分类管理规范**  

> **核心目标**：通过标准化目录结构，实现多类型项目（学习实验/开源测试/正式项目）的**高效定位、安全存储与协作复用**。
**最后更新**：2025-07-20 | #更新日志

---

### 🔍 **一、项目分类标准**  

根据开发目标与生命周期，将项目划分为三类，制定差异化管理策略：  

1. **`Labs/`**：学习实验型项目  
    - **特征**：短期验证技术点，无需完整文档。  
    - **管理重点**：代码片段+核心结论笔记，快速迭代。  
    - **示例**：`Labs/Python_WebScraping/notes.md`  
2. **`OpenSource/`**：开源测试项目  
    - **特征**：需复现性测试，记录兼容性问题。  
    - **管理重点**：环境配置+测试报告+版本依赖矩阵。  
    - **示例**：`OpenSource/Redis_Test_v6.0/compatibility.md`  
3. **`Official/`**：正式项目  
    - **特征**：长期维护，需完整文档与协作流程。  
    - **管理重点**：模块化代码+API文档+自动化测试。  
    - **示例**：`Official/ECommerce_Platform/src/`  

---

### 📂 **二、目录结构规范**  

#### **根目录结构**  

```Markdown
D:/Projects/               # 所有项目总目录
├── Labs/                  # 学习实验项目
│   ├── ProjectName_Tech/  # 项目名_技术点（如：React_Hooks_Demo）
│   │   ├── notes.md       # 核心结论与问题记录
│   │   └── snippet.py     # 关键代码片段
├── OpenSource/            # 开源测试项目
│   ├── ProjectName_vX.X/  # 项目名_版本号（如：Nginx_Config_Validator）
│   │   ├── env_config.yaml# 测试环境参数
│   │   └── stress_test.py 
└── Official/              # 正式项目
    ├── ProjectName/       # 项目名（如：Payment_Gateway）
    │   ├── docs/          # 设计文档/会议记录
    │   ├── src/           # 源代码（遵循语言规范）
    │   └── tests/         # 单元/集成测试脚本
```

#### **关键命名规则**  

- **文件夹**：`业务_技术_版本`（如：`ECommerce_Platform_Spring_v2.1`）  
- **文件**：`功能_日期_版本.后缀`（如：`UserAPI_Spec_20250720_v1.0.md`）  
- **禁止**：空格、中文、特殊符号（`!@#$`），用下划线`_`连接单词。

---

### ⚙️ **三、工具链配置**  

|工具类型|推荐工具|用途说明|
|-|-|-|
|**版本控制**|Git + GitHub/GitLab|所有项目强制初始化仓库|
|**实验管理**|Jupyter Notebook|Labs项目可视化记录代码与结论|
|**文档协作**|Notion + Obsidian|关联技术笔记与项目文档|
|**磁盘分析**|SpaceSniffer|定期扫描大文件，释放空间|
|**快速检索**|Everything|秒级定位文件（支持正则匹配）|


> **Git规范示例**：
- Labs项目：`main`分支直接提交，Commit信息前缀`[exp]`（如：`[exp] Add websocket test`）
- 正式项目：采用 [https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) 分支模型。

---

### 🔄 **四、维护与备份策略**  

1. **版本控制**  
    - 所有文档用Git管理，禁止本地存档。  
    - 关键配置（如数据库密码）存入`.env`文件，**禁止提交至仓库**（通过`.gitignore`过滤）。  
2. **备份频率**  
    - 每日：Git远程仓库自动同步（GitHub/GitLab）。  
    - 每周：`Projects/`目录增量备份至移动硬盘或云存储（推荐坚果云）。  
3. **清理规则**  
    - Labs项目：6个月无更新 → 归档至`Archives/2025H1/Labs/`。  
    - `Temp/`目录：每月1日清空。

---

### 💡 **五、快速回忆指南**  

当遗忘项目位置或规范时：  

1. **定位项目**：用`Everything`搜索关键词（如：`Redis_Test`） → 秒获路径。  
2. **查看结构**：打开项目内`README.md` → 检索#二目录结构规范章节。  
3. **重建环境**：进入`config/`目录 → 执行`setup_env.sh`（需预先编写）。  

---

### 📝 **六、附录：README模板示例**  

```Markdown
# ProjectName https://img.shields.io/badge/License-MIT-yellow.svg](LICENSE)

> **分类**: `Official` | **技术栈**: Spring Boot 3.2, MySQL 8.0  
> **简介**: 基于微服务的支付网关系统，支持多渠道路由。

## 📂 目录结构
```text
src/
├── main/
│   ├── java/com/payment/   # 核心逻辑
│   └── resources/config/    # 环境配置
tests/
├── unit/                   # 单元测试
└── integration/            # 集成测试
```

## ⚡ 快速开始

```Bash
git clone https://github.com/yourname/ProjectName
cp .env.example .env        # 填写实际配置
docker-compose up -d        # 启动依赖服务
```

## 🔒 数据备份

- **自动备份**: 每日 2:00 AM 同步至 S3 桶 `s3://project-backup/`
- **手动恢复**: `scripts/restore_backup.sh 20250720`

```Markdown
> 更多模板参考：https://blog.csdn.net/weixin_45742970/article/details/145785286

---

### ⏱️ **更新日志**  
- `2025-07-20`：初版发布，定义三类项目标准目录结构。  
- `2025-07-15`：增加Git分支策略说明。  

---

通过此README，您可快速回溯目录设计逻辑、工具使用规范及维护规则，减少“寻找文件”的时间损耗。**立即行动**：  
1. 为现有项目创建`README.md`，填写基础信息。  
```
