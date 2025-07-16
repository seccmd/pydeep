# Alpine.js 入门

Alpine.js 通过很低的成本提供了与 Vue 或 React 这类大型框架相近的响应式和声明式特性。

你可以继续操作 DOM，并在需要的时候使用 Alpine.js。

可以理解为 JavaScript 版本的 [Tailwind](https://tailwindcss.com/)。


## 使用 Vite、Alpine.js 和 Tailwind CSS 构建基础运行环境
[使用 Vite、Alpine.js 和 Tailwind CSS 构建基础运行环境 | 5ee博客](https://www.5ee.net/archives/nipINnsd)

本教程如何搭建一个结合了 Vite、Tailwind CSS、Preline UI、Vanilla JavaScript (ES6 Modules) 和 (可选的) Alpine.js 的现代化前端开发环境。这个技术栈非常适合构建静态优先、对 SEO 友好且具备现代交互功能的网站和主题模板。

Vite: 一个现代化的前端构建工具，它极大地提升了前端开发体验。Vite 通过在开发阶段利用浏览器原生的 ES 模块导入功能，实现了极快的冷启动和即时模块热更新。了解更多请访问：<https://cn.vite.dev/guide/>

Tailwind CSS: 一个高度可定制的、低级别的 CSS 框架，它为您提供了一系列原子化的 CSS 类，让您可以直接在 HTML 中快速构建用户界面，而无需编写自定义 CSS。了解更多请访问：<https://tailwindcss.com/docs/installation/using-vite>

Preline UI: 一个开源的 UI 组件库，提供了基于 HTML 和 Tailwind CSS 的预设计组件。您可以直接使用 Preline 提供的 HTML 结构，并结合其可选的 JavaScript 来添加交互功能。了解更多请访问：<https://preline.co/>

Alpine.js: (可选) 一个轻量级的 JavaScript 框架，用于在您的 HTML 标记中添加交互性。它借鉴了 Vue.js 和 Angular.js 的一些优秀特性，但保持了极简的体积和学习曲线，并且可以直接在 HTML 中使用。了解更多请访问：<https://alpinejs.dev/essentials/installation>

Vanilla JavaScript (ES6 Modules): 使用原生 JavaScript 并结合 ES Modules，可以实现代码的模块化和组织，按需为静态 HTML 组件添加更复杂的交互逻辑，或者集成其他现代 JS 插件。

## Vanilla JavaScript（原生 JavaScript）

Vanilla JavaScript（原生 JavaScript）指的是**不依赖任何第三方框架或库**（如 jQuery、React、Vue 等）时，直接使用浏览器原生支持的 JavaScript 进行开发。它强调“纯净、原生、无依赖”。

**ES6 Modules**（ECMAScript 2015 模块）是 JavaScript 在 ES6（2015年）标准中引入的官方模块化方案。它允许你将代码拆分为多个文件，并通过 import/export 语法进行模块间的引用和共享。

### 主要特点

#### 1. Vanilla JavaScript

* 只用浏览器自带的 JS 能力，不用任何第三方库。
* 代码更轻量、无额外依赖，兼容性好。
* 适合小型项目、学习原理、性能要求高的场景。

#### 2. ES6 Modules

* **模块化**：每个文件就是一个独立的模块，变量/函数/类不会污染全局作用域。
* **导出（export）**：可以把变量、函数、类等从一个模块导出。
* **导入（import）**：可以在另一个模块中引入需要的内容。
* **静态分析**：import/export 语法在编译时就能确定依赖关系，有利于打包优化。

### 示例

**math.js**

```JavaScript
// 导出
export function add(a, b) {
  return a + b;
}
```

**main.js**

```JavaScript
// 导入
import { add } from './math.js';

console.log(add(2, 3)); // 输出 5
```

### 在 Vite、现代浏览器中的应用

* 现代浏览器原生支持 ES6 Modules（通过 `<script type="module">`）。
* Vite 等现代构建工具默认支持 ES6 Modules，开发体验更好。

***

**总结**： Vanilla JavaScript (ES6 Modules) 就是“只用原生 JS，并用 import/export 语法进行模块化开发”，不依赖任何第三方框架或库。这是现代前端开发的基础能力之一。
