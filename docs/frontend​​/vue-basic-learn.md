# Vue 项目 小白入门实战教学

好的！下面我用最通俗的方式，手把手教你从零开始搭建一个 Vue 3 项目，适合小白入门实战。每一步都很详细，跟着做一定能学会！

***

## 一、准备工作

1. **安装 Node.js**

   访问 [Node.js 官网](https://nodejs.org/zh-cn/)，下载安装最新版（建议 LTS 版本）。

2. **安装 npm（Node.js 自带）**

   安装 Node.js 后，npm 也会自动安装好。

***

## 二、用 Vite 创建 Vue 3 项目

Vite 是现在最流行的前端脚手架，速度快，配置简单，非常适合新手。

### 1. 打开命令行（PowerShell/CMD/终端）

### 2. 输入以下命令，创建项目：

```Bash
npm create vite@latest my-vue-app
```

* 过程中会让你输入项目名（比如 my-vue-app）
* 选择框架时选 **Vue**
* 选择 JS 还是 TS，建议新手选 **JavaScript**

### 3. 进入项目目录

```Bash
cd my-vue-app
```

### 4. 安装依赖

```Bash
npm install
```

***

## 三、运行项目

```Bash
npm run dev
```

* 看到终端输出本地访问地址（如 <http://localhost:5173>）
* 用浏览器打开这个地址，看到 Vue 欢迎页，说明项目启动成功！

***

## 四、项目结构讲解

* `index.html`：项目入口 HTML

* `src/`：源码目录

  * `main.js`：入口 JS 文件
  * `App.vue`：主组件
  * `components/`：存放自定义组件

* `package.json`：项目依赖和脚本

* `vite.config.js`：Vite 配置文件

***

## 五、写一个自己的 Vue 组件

1. 打开 `src/components/HelloWorld.vue`，可以看到一个简单的 Vue 组件结构：

```Vue
<template>
  <h1>{{ msg }}</h1>
</template>

<script>
export default {
  props: {
    msg: String
  }
}
</script>
```

2. 你可以在 `src/App.vue` 里这样用它：

```Vue
<template>
  <HelloWorld msg="你好，Vue 小白！" />
</template>

<script setup>
import HelloWorld from './components/HelloWorld.vue'
</script>
```

***

## 六、修改页面内容

* 直接编辑 `App.vue` 或 `HelloWorld.vue`，保存后页面会自动刷新。

***

## 七、常用命令

* `npm run dev`：开发模式，热更新
* `npm run build`：打包生产环境
* `npm run preview`：本地预览打包结果

***

## 八、进阶推荐

* [Vue 3 官方文档](https://cn.vuejs.org/)
* [Vite 官方文档](https://vitejs.dev/guide/)

***

## 九、常见问题

* **端口被占用**：换个端口或关掉占用的程序
* **依赖安装慢**：可以换淘宝镜像 `npm config set registry https://registry.npmmirror.com`

***

如果你想集成 Tailwind CSS、Element Plus、Pinia 等，或者想了解 Vue 组件、路由、状态管理等进阶内容，随时告诉我，我可以继续详细讲解！
