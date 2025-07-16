# FastAPI 开始

学习跑通uv+fastapi两个重要核心组件

```Markdown
# 主文档流程
# Using uv with FastAPI 
# https://docs.astral.sh/uv/guides/integration/fastapi/

# 代码下载
git clone https://github.com/astral-sh/uv-fastapi-example

# To use uv with this application, inside the project directory run:
cd uv-fastapi-example
uv init --app

# Then, add a dependency on FastAPI:
uv add fastapi --extra standard

# From there, you can run the FastAPI application with:
uv run fastapi dev
uv run fastapi dev --host 0.0.0.0 --port 8080
```
