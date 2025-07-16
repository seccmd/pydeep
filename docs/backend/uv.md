# UV  in One

UV 官方文档学习
https://docs.astral.sh/uv/

## UV：速查表
[https://www.apframework.com/blog/essay/2025-06-07-Python-UV](https://www.apframework.com/blog/essay/2025-06-07-Python-UV)


下面是 UV 工作流程中的常见操作速查表，帮助您快速查找和使用 UV 的各种命令。

### 1 环境管理

|操作|UV 命令|传统对应命令|
|-|-|-|
|创建虚拟环境|`uv venv`|`python -m venv .venv`|
|创建指定 Python 版本的虚拟环境|`uv venv --python=3.12`|`python3.10 -m venv .venv`|
|安装 Python 版本|`uv python install 3.12`|使用 pyenv 或系统包管理器|
|列出可用的 Python 版本|`uv python list`|`pyenv versions`|
|激活虚拟环境|使用系统激活方式|`source .venv/bin/activate`|


### 2 包管理

|操作|UV 命令|传统对应命令|
|-|-|-|
|安装单个包|`uv pip install requests`|`pip install requests`|
|从 requirements.txt 安装|`uv pip install -r requirements.txt`|`pip install -r requirements.txt`|
|安装当前项目|`uv pip install -e .`|`pip install -e .`|
|安装开发依赖|`uv pip install -e ".[dev]"`|`pip install -e ".[dev]"`|
|生成锁文件|`uv pip compile requirements.in -o requirements.txt`|`pip-compile requirements.in -o requirements.txt`|
|升级单个包|`uv pip install --upgrade requests`|`pip install --upgrade requests`|


### 3 项目管理

|操作|UV 命令|传统对应命令|
|-|-|-|
|添加依赖|`uv add requests`|Poetry:`poetry add requests`|
|移除依赖|`uv remove requests`|Poetry:`poetry remove requests`|
|同步环境|`uv sync`|Poetry:`poetry install`|
|升级特定包|`uv sync --upgrade-package requests`|Poetry:`poetry update requests`|
|升级所有包|`uv lock --upgrade`|Poetry:`poetry update`|
|运行脚本|`uv run python script.py`|Poetry:`poetry run python script.py`|
|构建项目|`uv build`|Poetry:`poetry build`|


### 4 工具管理

|操作|UV 命令|传统对应命令|
|-|-|-|
|运行工具(不安装)|`uvx ruff check .`|pipx:`pipx run ruff check .`|
|运行特定版本工具|`uvx ruff@0.1.5 check .`|pipx:`pipx run --spec=ruff==0.1.5 ruff check .`|
|安装工具|`uv tool install ruff`|pipx:`pipx install ruff`|
|升级工具|`uv tool upgrade ruff`|pipx:`pipx upgrade ruff`|
|升级所有工具|`uv tool upgrade --all`|pipx:`pipx upgrade-all`|



### 关键区别

|命令|工具链|主要用途|修改项目依赖文件|安装环境|
|-|-|-|-|-|
|`uv add requests`  添加依赖并安装|Rye (uv)|项目管理  （添加+安装依赖）|是（pyproject.toml）|项目虚拟环境|
|`uv pip install requests`  仅安装包，不管理项目依赖|Astral (uv)|快速安装包（类似 pip）|否|当前 Python 环境|


---

### 如何选择？

- 如果你使用 **Rye** 管理项目，用`uv add`保持依赖声明和安装同步。
- 如果只需快速安装包（无项目管理），用`uv pip install`（替代传统`pip`）。


## UV：下一代Python包管理工具

<https://www.apframework.com/blog/essay/2025-06-07-Python-UV>

### 1. 创建和管理项目

UV提供了一套完整的命令用于创建和管理Python项目：

创建新项目

```Bash
# 创建一个新的Python项目目录
uv init example
# Initialized project `example` at `/路径/example`

# 查看目录内容：
cd example
tree -a -L 1
# 有三个默认文件：README.md、main.py、pyproject.toml
├── .git
├── .gitignore
├── .python-version
├── README.md
├── main.py
└── pyproject.toml


# 该 main.py 文件包含一个简单的“Hello world”程序。尝试一下
uv run main.py

# 初始化一个新的虚拟环境：uv venv，正确运行后得到虚拟环境信息
$ uv venv
> Using CPython 3.13.1
> Creating virtual environment at: .venv
> Activate with: source .venv/bin/activate

# 直接运行main.py也可以创建虚拟环境
uv run main.py

# 激活虚拟环境
source.venv/bin/activate
```

### 2. 依赖管理命令

UV 提供了一系列强大的依赖管理命令，以下是最常用的几个：

添加依赖 使用 uv add 命令可以向项目添加依赖。**该命令会自动更新 pyproject.toml 文件**、锁文件和项目环境：

```Markdown
# 添加单个包
uv add requests

# 指定版本约束
uv add 'requests==2.31.0'

# 添加 Git 依赖
uv add git+https://github.com/psf/requests

# 从 requirements.txt 文件添加所有依赖
uv add -r requirements.txt -c constraints.txt
删除依赖
使用 uv remove 命令可以删除项目依赖：

# 删除包
uv remove requests
升级依赖
使用 uv lock 命令配合 --upgrade-package 参数可以升级指定包：

# 升级特定包
uv lock --upgrade-package requests
该命令会尝试将指定包更新到最新的兼容版本，同时保持锁文件中其他依赖不变。

# 从 pyproject.toml 安装项目依赖
当你有一个包含 pyproject.toml 的项目时，可以使用以下命令安装所有依赖：

# 安装项目依赖
uv pip install -e .

# 安装包含开发依赖
uv pip install -e ".[dev]"

# 同步项目环境
# 使用 uv sync 命令可以确保项目环境与锁文件保持同步：

# 同步项目环境
uv sync

# 运行项目命令
uv run 命令可以在项目环境中运行脚本或命令。在每次运行前，UV 会验证锁文件是否与 pyproject.toml 同步，并确保环境与锁文件一致：

# 运行 Python 脚本
uv run main.py

# 构建项目分发包
uv build 命令可用于构建项目的源码分发包和二进制分发包（wheel）：

# 构建项目
uv build

# 查看构建结果
ls dist/
# 输出示例：
# Successfully built dist/example-0.1.0.tar.gz
# Successfully built dist/example-0.1.0-py3-none-any.whl
```

这些命令提供了一个完整的项目依赖管理工作流程，从添加依赖、删除依赖、升级依赖到运行项目和构建分发包。UV 的这些命令设计直观且高效，大大简化了 Python 项目的依赖管理。

### 3. 使用工具

UV 提供了强大的工具管理功能，可以替代 pipx 等工具来运行和管理 Python 工具。

运行工具（不安装） **uvx 命令可以在不安装**工具的情况下直接运行工具：

```Markdown
# 运行带参数的工具
uvx pycowsay "Hello from UV"
  -------------
< Hello from UV >
  -------------
   \   ^__^
    \  (oo)\_______
       (__)\       )\/\
           ||----w |
           ||     ||
运行 ruff 代码检查工具

# 运行 ruff 代码检查工具
uvx ruff check .
# All checks passed!

uv tool run ruff check .
# All checks passed!
注意：uvx 是 uv tool run 的便捷别名。使用 uvx 运行的工具会在临时的隔离环境中安装和运行。

指定工具版本
可以使用 @ 语法指定工具的版本：

# 运行特定版本的工具
uvx ruff@0.1.5 check .

# 运行最新版本的工具
uvx ruff@latest check .
也可以使用 --from 选项指定更复杂的版本约束：

# 指定版本范围
uvx --from 'ruff>0.2.0,<0.3.0' ruff check .
安装工具
如果经常使用某个工具，可以将其安装到持久环境中，并添加到 PATH 中：

# 安装 ruff 工具
uv tool install ruff

# 安装特定版本的工具
uv tool install 'ruff>=0.3.0'

# 从 Git 仓库安装工具
uv tool install git+https://github.com/astral-sh/ruff
安装工具后，可以直接在命令行中运行该工具，无需通过 UV 调用：

# 直接运行已安装的工具
ruff --version
注意：与 uv pip install 不同，安装工具不会在当前环境中提供其模块。这种隔离对于减少工具、脚本和项目之间的依赖冲突非常重要。

升级工具
使用 uv tool upgrade 命令可以升级已安装的工具：

# 升级特定工具
uv tool upgrade ruff

# 升级所有工具
uv tool upgrade --all
工具升级会尊重安装工具时提供的版本约束。例如，如果使用 uv tool install ruff >=0.3,<0.4 安装了 Ruff，然后运行 uv tool upgrade ruff，则将升级 Ruff 到 >=0.3,<0.4 范围内的最新版本。
```



## UV： 入门指南

一个用 Rust 写的 Python 包和项目管理器

先看它自己怎么吹的~

* 🚀 一款工具可替代`pip``pip-tools``pipx``poetry``pyenv``twine``virtualenv`以及更多。
* ⚡️ 比`pip`快 10-100 倍。
* 🗂️ 提供全面的项目管理，具有通用的锁文件。
* ❇️ 运行脚本，支持内联依赖元数据。
* 🛠️ 运行并安装作为 Python 包发布的工具。
* 🔩 包含与 pip 兼容的接口，以熟悉的命令行界面提升性能。
* 🖥️ 支持 macOS、Linux 和 Windows。

### 安装

```Bash
#Linux & MacOS
curl -LsSf https://astral.sh/uv/install.sh | sh
#Windows
powershell -ExecutionPolicy ByPass -c"irm https://astral.sh/uv/install.ps1 | iex"
```

### 基本使用

### 管理 Python

```Bash
# 寻找当前可用python解释器
uv python find

# 寻找可安装python解释器
uv python list

# 下载python解释器
uv python install 3.13

# 卸载 Python 版本
uv python uninstall

# 固定 Python 版本
uv python pin 3.13

# 安装虚拟环境，默认名字 .venv
uv venv --python 3.11
```

### 依赖管理

```Bash
# 添加依赖
uv add requests

# 移除依赖
uv remove requests

# 同步依赖
uv sync

# 安装依赖：如果 requirements.txt 或 pyproject.toml 中定义了新依赖，uv sync 会安装它们
# 卸载多余依赖：如果当前环境中存在未在 requirements.txt 或 pyproject.toml 中定义的依赖，
# uv sync 会自动删除它们，以保持环境的干净
```

### 运行命令

`uv run`命令的作用是在 uv 管理的虚拟环境中运行命令

`uv run`的主要功能

1. 自动激活虚拟环境：在`uv venv`创建的环境中执行命令，而不需要手动`source venv/bin/activate`
2. 执行 Python 脚本：可以直接运行 Python 相关命令，如`python`、`pytest`、`flask run`等
3. 运行任意终端命令：不仅限于 Python，还可以运行`bash`、`sh`等

> 即，uv run 的作用是激活当前 uv 项目的虚拟环境

### 运行二进制文件

`uvx`的作用是在 UV 虚拟环境中运行可执行文件，相当于`uv run`，但专门用于运行可执行二进制文件

```Bash
uvx black .

uvx ruff check .

uvx mypy my_script.py
```

什么时候用`uvx`？

* 运行已安装的 CLI 工具（`black`、`ruff`、`mypy`、`pyright`）
* 确保使用 UV 虚拟环境中的二进制文件，而不是系统全局版本
* 在 CI/CD 或 Docker 中执行格式化、静态检查等任务

## 项目结构

```Bash
.python-version
pyproject.toml
uv.lock
```

`.python-version`：uv 使用的 python 版本

`pyproject.toml`: uv 的元数据信息

`uv.lock`：用于确保所有依赖的版本一致，避免团队或生产环境中的版本差异问题。

### 修改 pip 源

```Bash
# 修改 pip 源

# 添加到 pyproject.toml文件中
[[tool.uv.index]]
url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple" # 清华源
```

## Python 虚拟环境

### 1.Python 虚拟环境存在的意义

试想一下，你的公司有两个 Django 项目，一个是 django1.11 版本，一个是 django4.2 版本，而你本地只有一个 python 解释器，那你如何避免这两个不同版本的 django 之间的影响呢？

如果将两个 django 包下载到同一个 python 第三方包目录下肯定不行，python 也不允许你这么做。

那么虚拟环境就完美的解决了这一问题，通过创建虚拟环境，你可以复制出两个相互隔绝的 python 解释器环境，避免了两个不同版本 django 包的干扰，它相当于复制了本地的 python 解释器环境到指定的地方，从而避免了这类问题。

### 2.Python 虚拟环境的管理包工具

现在，管理 Python 虚拟环境的工具数不胜数，这里简单列出几个

* venv:[文档](https://docs.python.org/zh-cn/3/library/venv.html)
* virtualenv:[文档](https://virtualenv.pypa.io/en/latest/#)
* pyenv:[文档](https://github.com/pyenv/pyenv?tab=readme-ov-file#how-it-works)
* pipenv:[文档](https://pipenv.pypa.io/en/latest/)

### 3.virtualenv 工具管理虚拟环境

因为管理 Python 虚拟环境的工具包太多，每一个都学会太浪费时间(个人想法)，所以这里只介绍 virtualenv，个人觉得简单易用。

* `下载virtualenv`

```Python
pip install virtualenv
```

* `创建虚拟环境`

```Python
virtualenv venv
```

* `激活虚拟环境`

```Bash
sourcevenv/bin/activate
```

* `退出虚拟环境`

```Bash
deactivate
```

* [python](https://www.xxrbear.cn/tags/python/)
