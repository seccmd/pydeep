# Jupyter 环境快速搭建

[Jupyter Notebook环境搭建与使用全攻略 - 数字安全极客](https://www.seccmd.net/2024/10/28/basetools/Jupyter/)

### uv版一键安装jupyter-lab 临时环境root权限

```Markdown
# Linux & MacOS
curl -LsSf https://astral.sh/uv/install.sh | sh
# 临时环境root权限，明确指定版本
mkdir -p /opt/jupyter-lab && cd /opt/jupyter-lab
uv python pin 3.12
uvx jupyter lab --port 8888 --ip=0.0.0.0 --allow-root
nohup sh j.sh &

## Error
## - Running as root is not recommended. Use --allow-root to bypass.
## Other
## uv pip install jupyter
## Token authentication:
## http://127.0.0.1:8888/tree?token=26c85d3818be4907300f594c54c7ed3190a6af5ee88c65d9
```

### 安装jupyter notebook

```Markdown
## Google 云服务
https://colab.research.google.com/

## 安装jupyter notebook

`$ pip3 install jupyter`

通过国内镜像源安装第三方包的方法（安装速度更快）

`$ pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple jupyter`

`$ pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple feedparser`

`$ pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple lxml`

`$ pip3 install html2text`

`$ pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple scrapy`

## 使用jupyter notebook

`$ jupyter notebook `

指定网络地址和端口

`$ jupyter notebook --port 8888 --ip=0.0.0.0 `

查看登陆授权码 Token authentication

`$ jupyter notebook list`
```

### Linux Jupyter环境初始化

目的：基于Kali的notebook，快速部署开发或工具的环境

```Markdown
# 第一步：打开一个 kali 或 Linux虚拟机
python -V     # Linux 默认安装的 python 版本
python3 -V    # 新的系统只安装了Pthon3    

# 第二步：（主机位置，国外国内）Python 设置国内镜像源安装第三方包,永久修改
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip config list

# 第三步，安装运行 notebook
pip install jupyter --upgrade  # 自动升级，才能正常运行。
jupyter notebook --port 8888 --ip=0.0.0.0 --allow-root # root 权限运行，避免安装部署很多麻烦


# 第四步，扫描方案，导入剧本
- 浏览器打开：http://127.0.0.1:8888/tree
- 远程访问需要密码登录：http://kali:8888/tree?token=xxx
- 选择浏览器桌面文件，导入剧本

# 第五步，剧本部署完成后，开始扫描


# === FAQ ===

# 查看登陆授权码 Token authentication 远程访问时需要密码登录
jupyter notebook list  

# 报错：jupyter 命令的路径
export PATH=$PATH:~/.local/bin/  
```
