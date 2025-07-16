# One-API

Cambridge: <https://dictionary.cambridge.org/dictionary/english/repository>

Code Repository: <https://github.com/songquanpeng/one-api>

### 基于 Docker 进行部署

```Markdown
# 使用 SQLite 的部署命令：
docker run --name one-api -d --restart always -p 3000:3000 -e TZ=Asia/Shanghai -v /opt/jupyter-lab/one-api/data:/data justsong/one-api
# 使用 MySQL 的部署命令，在上面的基础上添加 `-e SQL_DSN="root:123456@tcp(localhost:3306)/oneapi"`，请自行修改数据库连接参数，不清楚如何修改请参见下面环境变量一节。
# 例如：
docker run --name one-api -d --restart always -p 3000:3000 -e SQL_DSN="root:123456@tcp(localhost:3306)/oneapi" -e TZ=Asia/Shanghai -v /home/ubuntu/data/one-api:/data justsong/one-api
```

### 测试环境

[http://47.76.253.98:3000/](http://47.76.253.98:3000/user/edit)

root/Test@两万七

