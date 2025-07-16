# vue3安装tailwindcss报错

[vue3安装tailwindcss报错：npm error could not determine executable to run](https://www.xiaohev.com/post/17)

在使用vue3的安装tailwind css时候当使用npx tailwindcss init -p出现了报错：npm error could not determine executable to run。我以为是我的node版本太高于是乎经过nvm切换，卸载从新安装等一系列操作后我注意到并没有什么用。各种问ai查找资料终于经过了一上午的折腾找到了原因，我访问的tailwind css网站是中文的，而这个中文网站是社区维护！！！tailwind css最新的版本是4.x，由于4.x的配置方法改变所以按照3.x的版本配置必然不行。

## 解决方案

如果使用3.x的版本那么只用安装tailwind css时候指定版本即可，后续安装可以按照文档继续配置：

```JavaScript
npm install-Dtailwindcss@3 postcss autoprefixer
```

***

第二种是使用4.x的版本

1-首先使用npm进行安装：

```JavaScript
npm install tailwindcss @tailwindcss/vite
```

2-修改vite.config.ts/js的配置：

```TypeScript
import{defineConfig}from'vite'importtailwindcssfrom'@tailwindcss/vite'exportdefaultdefineConfig({plugins:[tailwindcss(),],})
```

3-可以创建一个css文件也可以使用已经有的css文件，组要注意的是如果创建新的css文件需要在main.ts/js导入：

```JavaScript
@import"tailwindcss";
```

接下来就可以愉快的进行编码了。

这里需要注意的是tailwind css的官网是 [https://tailwindcss.com 中文网站是由社区维护的应该还没有更新最新的版本！！！](https://tailwindcss.com/)
