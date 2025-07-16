# Github in One


## GitHub上传指导文档

本文档将详细指导您如何将AI问答机器人项目上传到GitHub，包括Git环境配置、仓库创建、代码提交等完整流程。

## 📋 准备工作

### 1. 安装Git

如果您还没有安装Git，请先安装：

**Windows:**

* 下载并安装：<https://git-scm.com/download/win>
* 或使用包管理器：`winget install Git.Git`

**macOS:**

```Bash
# 使用Homebrew
brew install git

# 或使用Xcode命令行工具
xcode-select --install
```

**Linux (Ubuntu/Debian):**

```Bash
sudo apt update
sudo apt install git
```

### 2. 配置Git用户信息

```Bash
# 设置用户名（将显示在提交记录中）
git config --global user.name "您的用户名"

# 设置邮箱（建议使用GitHub邮箱）
git config --global user.email "your.email@example.com"

# 验证配置
git config --global --list
```

### 3. 创建GitHub账户

如果您还没有GitHub账户：

1. 访问 <https://github.com>
2. 点击"Sign up"注册账户
3. 验证邮箱地址

## 🚀 上传步骤

### 步骤1：初始化本地Git仓库

在项目根目录（`ai-chatbot-demo`）中打开终端：

```Bash
# 初始化Git仓库
git init

# 查看当前状态
git status
```

### 步骤2：添加文件到Git

```Bash
# 添加所有文件到暂存区
git add .

# 或者选择性添加文件
git add README.md
git add frontend/
git add backend/
git add docs/

# 查看暂存区状态
git status
```

### 步骤3：创建首次提交

```Bash
# 创建首次提交
git commit -m "🎉 初始提交：AI问答机器人演示系统

- ✅ 完整的前后端架构
- ✅ Vue3 + FastAPI 技术栈
- ✅ DeepSeek AI模型集成
- ✅ 详细的学习文档
- ✅ 一键启动脚本"

# 查看提交历史
git log --oneline
```

### 步骤4：在GitHub创建远程仓库

1. **登录GitHub**：访问 <https://github.com> 并登录

2. **创建新仓库**：

   * 点击右上角的 "+" 按钮
   * 选择 "New repository"

3. **配置仓库信息**：

   * **Repository name**: `ai-chatbot-demo`
   * **Description**: `基于Vue3+FastAPI的AI问答机器人演示系统，集成DeepSeek大模型`
   * **Visibility**: 选择 Public（公开）或 Private（私有）
   * **不要**勾选 "Add a README file"（我们已经有了）
   * **不要**勾选 "Add .gitignore"（我们已经创建了）
   * **License**: 可选择 MIT License

4. **点击 "Create repository"**

### 步骤5：连接本地仓库到GitHub

复制GitHub提供的仓库URL，然后在本地执行：

```Bash
# 添加远程仓库（替换为您的实际URL）
git remote add origin https://github.com/您的用户名/ai-chatbot-demo.git

# 验证远程仓库
git remote -v

# 推送代码到GitHub
git push -u origin main
```

如果遇到分支名称问题，可能需要：

```Bash
# 重命名分支为main（GitHub默认分支名）
git branch -M main

# 然后再推送
git push -u origin main
```

## 🔐 身份验证

### 方法1：使用Personal Access Token（推荐）

1. **生成Token**：

   * 访问 GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   * 点击 "Generate new token (classic)"
   * 设置过期时间和权限（至少需要 `repo` 权限）
   * 复制生成的token（只显示一次）

2. **使用Token**：

```Bash
# 推送时使用token作为密码
git push -u origin main
# 用户名：您的GitHub用户名
# 密码：刚才生成的token
```

### 方法2：使用SSH密钥

1. **生成SSH密钥**：

```Bash
# 生成新的SSH密钥
ssh-keygen -t ed25519 -C "your.email@example.com"

# 启动ssh-agent
eval "$(ssh-agent -s)"

# 添加密钥到ssh-agent
ssh-add ~/.ssh/id_ed25519
```

2. **添加公钥到GitHub**：

```Bash
# 复制公钥内容
cat ~/.ssh/id_ed25519.pub
```

```
- 访问 GitHub Settings → SSH and GPG keys
- 点击 "New SSH key"
- 粘贴公钥内容
```

3. **使用SSH URL**：

```Bash
# 更改远程仓库URL为SSH格式
git remote set-url origin git@github.com:您的用户名/ai-chatbot-demo.git
```

## 📝 后续维护

### 日常提交流程

```Bash
# 1. 查看文件变更
git status

# 2. 添加变更文件
git add .
# 或选择性添加
git add 文件名

# 3. 提交变更
git commit -m "📝 更新说明：具体修改内容"

# 4. 推送到GitHub
git push
```

### 提交信息规范

建议使用以下格式的提交信息：

```Bash
# 功能添加
git commit -m "✨ 新增：添加用户认证功能"

# 问题修复
git commit -m "🐛 修复：解决API响应超时问题"

# 文档更新
git commit -m "📝 文档：更新部署指南"

# 性能优化
git commit -m "⚡ 优化：提升数据库查询性能"

# 代码重构
git commit -m "♻️ 重构：优化组件结构"

# 样式调整
git commit -m "💄 样式：调整聊天界面布局"

# 测试相关
git commit -m "✅ 测试：添加API单元测试"
```

### 分支管理

```Bash
# 创建新分支
git checkout -b feature/新功能名称

# 切换分支
git checkout main
git checkout feature/新功能名称

# 合并分支
git checkout main
git merge feature/新功能名称

# 删除分支
git branch -d feature/新功能名称

# 推送分支到GitHub
git push origin feature/新功能名称
```

## 📁 项目结构说明

确保以下重要文件已正确配置：

### .gitignore 文件

```Markdown
# 环境变量文件
.env
.env.local

# 依赖目录
node_modules/
__pycache__/

# 构建输出
dist/
build/

# 数据库文件
*.db
*.sqlite

# 日志文件
logs/
*.log
```

### [README.md](http://README.md) 文件

确保包含：

* 项目描述
* 安装说明
* 使用方法
* 技术栈
* 贡献指南

## 🔧 常见问题解决

### 1. 推送被拒绝

```Bash
# 如果远程仓库有更新，先拉取
git pull origin main

# 解决冲突后再推送
git push origin main
```

### 2. 忘记添加.gitignore

```Bash
# 如果已经提交了不应该提交的文件
git rm --cached 文件名
git commit -m "🗑️ 移除：删除不应该提交的文件"
```

### 3. 修改最后一次提交

```Bash
# 修改最后一次提交信息
git commit --amend -m "新的提交信息"

# 添加文件到最后一次提交
git add 遗漏的文件
git commit --amend --no-edit
```

### 4. 撤销提交

```Bash
# 撤销最后一次提交（保留文件修改）
git reset --soft HEAD~1

# 完全撤销最后一次提交
git reset --hard HEAD~1
```

## 🌟 最佳实践

### 1. 提交频率

* 经常提交小的、逻辑完整的更改
* 避免一次提交大量不相关的修改

### 2. 分支策略

* `main` 分支：稳定的生产代码
* `develop` 分支：开发中的代码
* `feature/*` 分支：新功能开发
* `hotfix/*` 分支：紧急修复

### 3. 代码审查

* 使用Pull Request进行代码审查
* 添加详细的PR描述
* 确保CI/CD检查通过

### 4. 文档维护

* [及时更新README.md](http://xn--README-o35jo69i8ram3f.md)
* 维护API文档
* 记录重要的架构决策

## 📚 相关资源

* [Git官方文档](https://git-scm.com/doc)
* [GitHub官方指南](https://docs.github.com/)
* [Git提交信息规范](https://www.conventionalcommits.org/)
* [GitHub Flow工作流](https://guides.github.com/introduction/flow/)

***

🎉 **恭喜！** 您的AI问答机器人项目现在已经成功上传到GitHub了！

记住定期推送您的代码更改，并保持良好的提交习惯。这样不仅能保护您的代码，还能让其他开发者更容易理解和贡献您的项目。
