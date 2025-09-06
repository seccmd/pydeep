# k3s 部署 Jenkins

搭建一个完整的 CI/CD（持续集成/持续部署）系统，核心组件主要分为以下几类：

### 1. 源代码管理系统 (SCM)

这是整个 CI/CD 流程的起点。所有的代码更改都会在这里进行管理。

* **作用：** 存储和追踪项目的源代码。当开发者提交新代码时，会触发 CI/CD 流水线。
* **常见工具：** Git、GitHub、GitLab、Bitbucket。

---

### 2. 持续集成服务器 (CI Server)

这是 CI/CD 流水线的大脑。它负责协调和执行各种任务。

* **作用：** 自动监控代码仓库，在代码有新提交时，自动拉取代码、运行测试、构建项目。
* **常见工具：** Jenkins、GitLab CI/CD、GitHub Actions、TeamCity。

---

### 3. 构建工具

用于将源代码编译成可执行的程序或软件包。

* **作用：** 根据项目类型（如 Java、Python、Go 等），将代码和依赖项打包成可部署的产物。
* **常见工具：** Maven、Gradle (Java)、npm、Yarn (Node.js)、Docker。

---

### 4. 自动化测试框架

确保代码质量，是 CI 流程中至关重要的一步。

* **作用：** 自动运行单元测试、集成测试、端到端测试，以验证代码的正确性，并在出现问题时及时反馈。
* **常见工具：** JUnit (Java)、Pytest (Python)、Selenium (端到端测试)。

---

### 5. 容器化平台

用于打包应用程序及其所有依赖项，以确保在任何环境中都能一致地运行。

* **作用：** 将应用程序和其运行环境（库、配置等）打包成一个独立的容器，便于在不同环境中部署。
* **常见工具：** Docker。

---

### 6. 部署工具

负责将构建好的应用部署到目标环境中（如开发、测试、生产环境）。

* **作用：** 自动化部署过程，包括配置环境、更新应用程序、回滚等。
* **常见工具：**
    * **容器编排：** Kubernetes、Docker Swarm。
    * **配置管理：** Ansible、Chef、Puppet。
    * **通用部署：** Spinnaker、ArgoCD。

---

### 7. 构件仓库/制品库 (Artifact Repository)

用于存储构建生成的软件包或镜像。

* **作用：** 统一管理和存储可部署的产物（如 Docker 镜像、jar 包），供后续部署流程使用。
* **常见工具：** Nexus、Artifactory、Harbor (Docker 镜像仓库)。

---

### 8. 监控和日志系统

在部署后，用于持续监控应用程序的健康状况。

* **作用：** 收集和分析日志、性能指标，以便在出现问题时能够快速发现和定位。
* **常见工具：** Prometheus、Grafana (监控)、ELK Stack (Elasticsearch、Logstash、Kibana) (日志)。

这些核心组件共同协作，形成了一个完整的自动化工作流，极大地提高了软件开发和交付的效率与可靠性。

-----

### 简化版 `jenkins-deployment.yaml`

这个单一文件包含了 Deployment 和 Service 两个资源定义。

```yaml
# jenkins-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
      - name: jenkins
        # 使用官方长期支持版本镜像
        image: jenkins/jenkins:lts-jdk11
        ports:
        - containerPort: 8080
        - containerPort: 50000
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 32000 # 外部访问端口，范围 30000-32767
```

**配置说明**：

  * **Deployment**：定义了如何运行 Jenkins 容器。这里我们指定了使用 `jenkins/jenkins:lts-jdk11` 镜像，并暴露了 `8080` 和 `50000` 端口。由于是临时使用，没有配置 `volumeMounts`。
  * **Service**：定义了如何从外部访问 Jenkins。我们使用 **NodePort** 类型，将集群内部的 `8080` 端口映射到集群节点的 `32000` 端口，以便从外部浏览器访问。

-----

### 部署步骤

1.  **创建命名空间**：如果你的 `jenkins` 命名空间还不存在，需要先创建它。

    ```bash
    kubectl create namespace jenkins
    ```

2.  **执行部署**：将上面的 YAML 内容保存为 `jenkins-deployment.yaml`，然后执行以下命令。

    ```bash
    kubectl apply -f jenkins-deployment.yaml
    ```

    这条命令会同时创建 Deployment 和 Service。

3.  **获取初始密码**：

      * **获取 Pod 名称**：
        ```bash
        kubectl get pods -n jenkins
        ```
      * **获取密码**：
        ```bash
        kubectl exec <你的Jenkins Pod名称> -n jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
        ```

4.  **访问 Jenkins**：在浏览器中访问 `http://<你的k3s节点IP>:32000`。

这个简化版本非常适合快速验证 CI/CD 流程或进行临时实验。如果你需要保留配置或构建历史，记得使用持久化存储方案。

当然，用 Jenkins 搭建 CI/CD 流程是业界的标准实践。和 GitHub Actions 不同，Jenkins 需要自己搭建和配置，但它提供了无与伦比的灵活性。

下面是一个基于 Jenkins 的最简 CI/CD 教程，我们将继续使用之前的 Python 项目作为例子。

-----

### 第一步：安装和运行 Jenkins

最简单的方法是使用 Docker 来运行 Jenkins。

1.  **安装 Docker**：确保你的机器上已安装 Docker。

2.  **创建 Jenkins 数据目录**：

    ```bash
    mkdir jenkins_home
    ```

3.  **运行 Jenkins 容器**：

    ```bash
    docker run \
      -d \
      -v $(pwd)/jenkins_home:/var/jenkins_home \
      -p 8080:8080 \
      -p 50000:50000 \
      --name my-jenkins \
      jenkinsci/blueocean
    ```

      * `-d`：后台运行
      * `-v`：将本地 `jenkins_home` 目录挂载到容器中，用于持久化数据
      * `-p`：将容器的 8080 和 50000 端口映射到宿主机
      * `jenkinsci/blueocean`：这是一个包含了 Blue Ocean UI 的 Jenkins 镜像，界面更现代化。

4.  **获取初始管理员密码**：

      * 运行命令 `docker logs my-jenkins`
      * 找到日志中类似 `Jenkins initial setup is required. An admin password has been generated and is stored at: /var/jenkins_home/secrets/initialAdminPassword` 的部分。
      * 复制下面的 32 位密码。

5.  **访问 Jenkins**：

      * 在浏览器中访问 `http://localhost:8080`。
      * 输入刚才复制的密码，然后点击 **Continue**。
      * 选择 **Install suggested plugins**，Jenkins 会自动安装一套常用的插件。
      * 创建第一个管理员用户，然后点击 **Save and Finish**。

-----

### 第二步：配置 Jenkins 凭据和工具

1.  **安装必要的插件**：

      * 登录 Jenkins，进入 **Manage Jenkins** -\> **Plugins**。
      * 搜索并安装 **Docker Pipeline** 插件。

2.  **配置 Docker Hub 凭据**：

      * 进入 **Manage Jenkins** -\> **Credentials** -\> **System** -\> **Global credentials (unrestricted)** -\> **Add Credentials**。
      * **Kind** 选择 **Username with password**。
      * **Username**：你的 Docker Hub 用户名
      * **Password**：你的 Docker Hub Access Token
      * **ID**：例如 `dockerhub-creds` (后面在 `Jenkinsfile` 中会用到)

3.  **配置 Git 工具**：

      * 进入 **Manage Jenkins** -\> **Global Tool Configuration**。
      * 找到 **Git**，点击 **Add Git**，配置 Git 的安装路径。如果你在 Docker 容器中运行 Jenkins，通常不需要额外配置。

-----

### 第三步：在项目中添加 Jenkinsfile

`Jenkinsfile` 是 Jenkins Pipeline 的配置文件，它使用 Groovy 语言来描述 CI/CD 流程。

在你的 Python 项目根目录下，创建一个名为 `Jenkinsfile` 的文件，内容如下：

```groovy
// Jenkinsfile
pipeline {
    // 定义流水线代理，这里使用 Docker 镜像作为环境
    agent {
        docker {
            image 'python:3.9-slim'
            args '-u root'
        }
    }

    // 定义环境变量
    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username' // 替换成你的 Docker Hub 用户名
        IMAGE_NAME = "your-repo-name" // 替换成你的镜像名称
    }

    // 定义流水线的各个阶段
    stages {
        stage('Build and Test') {
            steps {
                // 检出代码
                checkout scm
                
                // 安装依赖
                sh 'pip install -r requirements.txt'
                
                // 运行测试
                sh 'pytest'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // 构建 Docker 镜像
                sh "docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest ."
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // 使用之前配置的凭据登录 Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        // 推送镜像
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }
        
        // 部署阶段可以根据你的需要来添加，比如：
        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh "kubectl apply -f k8s-deploy.yml"
        //     }
        // }
    }
}
```

  * **agent**：`agent` 指令指定了流水线运行的环境。我们使用 `docker` 代理，让 Jenkins 在一个临时的 Python 容器中运行所有命令，确保环境一致性。
  * **environment**：定义了一些环境变量，方便在流水线中使用。
  * **stages**：流水线被分为多个阶段，每个阶段代表一个逻辑步骤。
  * **steps**：每个阶段包含一系列步骤，使用 `sh` 命令来执行 Shell 脚本。
  * **withCredentials**：这是一个非常重要的步骤，它安全地从 Jenkins 凭据库中获取敏感信息，并将其作为环境变量提供给脚本。

-----

### 第四步：创建 Jenkins 流水线项目

1.  **提交 `Jenkinsfile` 到 Git 仓库**：

    ```bash
    git add .
    git commit -m "feat: add Jenkinsfile"
    git push origin main
    ```

2.  **在 Jenkins 中创建项目**：

      * 返回 Jenkins 界面，点击 **New Item**。
      * **输入项目名称**，比如 `my-python-app`。
      * 选择 **Pipeline**，然后点击 **OK**。

3.  **配置 Pipeline**：

      * 在 **General** 标签页，勾选 **GitHub project** 并填入你的 GitHub 仓库 URL。
      * 在 **Pipeline** 标签页，**Definition** 选择 **Pipeline script from SCM**。
      * **SCM** 选择 **Git**。
      * **Repository URL**：你的 Git 仓库地址。
      * **Credentials**：如果你仓库是私有的，需要添加 Git 凭据。
      * **Script Path**：保持默认的 `Jenkinsfile`。

4.  **保存并构建**：

      * 点击 **Save**。
      * 在项目主页点击 **Build Now**。

-----

### 第五步：观察结果

  * Jenkins 会自动从你的 Git 仓库拉取代码，并根据 `Jenkinsfile` 的定义执行流水线。
  * 你可以在 Jenkins 项目的 **Console Output** 中查看详细的日志，看到每个阶段的执行情况。
  * 当所有阶段都成功执行后，你的 Docker 镜像就会被构建并推送到 Docker Hub。

恭喜！你已经成功搭建了一个基于 Jenkins 的 CI/CD 流程。Jenkins 的强大之处在于，你可以在 `Jenkinsfile` 中添加任何复杂的逻辑，例如在测试失败时发送通知、或者部署到 Kubernetes 集群等。这是一个很好的起点，可以帮助你进一步探索更高级的 CI/CD 实践。

-----

如果你想快速上手，体验一个最简单的 CI/CD 流程，最好的方法是利用一个集成了 CI/CD 功能的 Git 平台，比如 **GitHub Actions** 或 **GitLab CI/CD**。这样你就不需要单独搭建 CI 服务器，可以省去很多麻烦。

这里我以 **GitHub Actions** 为例，它非常流行，而且对于开源项目是免费的。

-----

### 第一步：准备一个项目

你需要一个可以在 CI/CD 流程中进行构建和测试的项目。一个简单的 Python 项目就足够了。

1.  **创建一个新的 GitHub 仓库。**

2.  **克隆到本地**：`git clone [你的仓库地址]`

3.  **创建项目文件**：

      * 在本地项目文件夹中，创建一个 `app.py` 文件，内容如下：
        ```python
        # app.py
        def add(a, b):
            return a + b

        def subtract(a, b):
            return a - b

        if __name__ == '__main__':
            print(f"1 + 2 = {add(1, 2)}")
        ```
      * 再创建一个 `test_app.py` 文件，用于单元测试：
        ```python
        # test_app.py
        from app import add, subtract

        def test_add():
            assert add(1, 2) == 3
            assert add(-1, 1) == 0
            assert add(0, 0) == 0

        def test_subtract():
            assert subtract(3, 1) == 2
            assert subtract(1, 3) == -2
        ```
      * 创建一个 `requirements.txt` 文件，用于指定依赖：
        ```
        pytest
        ```

4.  **提交并推送到 GitHub**：

    ```bash
    git add .
    git commit -m "feat: initial project setup"
    git push origin main
    ```

-----

### 第二步：配置 CI 流程

现在，我们要在 GitHub 仓库里配置 CI/CD 流程。

1.  **在 GitHub 仓库页面**，点击 **Actions** 标签。

2.  **选择一个模板**：GitHub 会推荐一些模板。你可以在搜索框里搜索 "Python" 并选择一个，或者直接点击 "set up a workflow yourself" 来创建一个空文件。

3.  **编写 CI/CD 配置文件**：

      * GitHub 会为你创建一个 `.github/workflows/main.yml` 文件。在这个文件中，你将定义你的 CI 流程。
      * 复制以下内容到这个文件中，然后点击 **Start commit**：

    <!-- end list -->

    ```yaml
    # .github/workflows/main.yml
    name: CI/CD Pipeline

    # 什么时候触发这个工作流
    on:
      push:
        branches:
          - main # 当代码推送到 main 分支时触发

    # 定义工作流中的任务
    jobs:
      build-and-test: # 任务名称
        runs-on: ubuntu-latest # 运行环境

        steps:
        # 步骤1: 检出代码
        - uses: actions/checkout@v3

        # 步骤2: 设置 Python 环境
        - name: Set up Python
          uses: actions/setup-python@v4
          with:
            python-version: '3.9' # 指定 Python 版本

        # 步骤3: 安装依赖
        - name: Install dependencies
          run: |
            python -m pip install --upgrade pip
            pip install -r requirements.txt

        # 步骤4: 运行测试
        - name: Run tests
          run: |
            pytest # 运行我们写的测试
    ```

-----

### 第三步：体验 CI 流程

现在，你的 CI 流程已经配置好了。让我们来体验它。

1.  **触发 CI**：

      * 在本地修改 `app.py` 文件，比如修改 `add` 函数，故意让它出错：
        ```python
        def add(a, b):
            return a + b + 1  # 故意让它出错
        ```
      * 提交并推送到 GitHub：
        ```bash
        git add .
        git commit -m "feat: introduce a bug"
        git push origin main
        ```

2.  **观察结果**：

      * 回到你的 GitHub 仓库，再次点击 **Actions** 标签。
      * 你会看到一个新的工作流正在运行。点击它，你可以看到每个步骤的详细日志。
      * 你会发现 **Run tests** 步骤失败了，因为它无法通过你写的 `test_add` 测试。
      * 这时，CI 系统会给你反馈，提醒你代码有问题，阻止你将有问题的代码合并到主分支。

3.  **修复并再次触发**：

      * 回到本地，修复 `app.py` 中的错误。
      * 再次提交并推送。
      * 你会看到一个新的工作流被触发，这次所有的步骤都会成功。

恭喜你！你已经完整地体验了一次最基本的**持续集成 (CI)** 流程：**提交代码 -\> 自动构建 -\> 自动测试 -\> 获得结果**。

虽然这只是一个非常简单的例子，但它涵盖了 CI/CD 的核心思想：**自动化**和**快速反馈**。你可以在这个基础上，进一步探索如何添加部署步骤，实现完整的 CI/CD 流程。

---

好的，我们继续在上一个**最简 CI 流程**的基础上，添加 **CD (持续部署)** 部分，来实现一个完整的 CI/CD 流程。

我们将扩展之前的 GitHub Actions 配置文件，增加两个主要步骤：

1.  **构建 Docker 镜像**：将我们的 Python 应用打包成一个独立的、可部署的 Docker 镜像。
2.  **部署到服务器**：当镜像构建成功后，自动将其部署到一台远程服务器上。

### 第一步：准备 Docker 和远程服务器

你需要一个可以部署应用的远程服务器（例如，一台云服务器或自己的电脑），并且上面已经安装了 **Docker**。

1.  **在你的项目根目录创建 `Dockerfile` 文件**：
    `Dockerfile` 是一个用于构建 Docker 镜像的脚本文件。

    ```dockerfile
    # Dockerfile
    # 使用官方 Python 镜像作为基础
    FROM python:3.9-slim

    # 设置工作目录
    WORKDIR /app

    # 复制依赖文件并安装
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt

    # 复制所有项目文件到镜像中
    COPY . .

    # 定义容器启动时执行的命令
    CMD ["python", "./app.py"]
    ```

2.  **配置 GitHub Secrets**：
    为了安全地将 Docker 镜像推送到 Docker Hub 或其他镜像仓库，以及连接到远程服务器，我们需要将敏感信息（如用户名、密码、SSH 密钥等）配置为 GitHub Secrets。

      * **登录 Docker Hub**：如果你还没有账号，请注册一个。
      * 在你的 GitHub 仓库中，进入 **Settings** -\> **Secrets and variables** -\> **Actions**。
      * 点击 **New repository secret**，创建以下 Secrets：
          * `DOCKERHUB_USERNAME`：你的 Docker Hub 用户名
          * `DOCKERHUB_TOKEN`：你的 Docker Hub 访问令牌（Access Token），可以在 Docker Hub 的账户设置里生成。
          * `REMOTE_HOST`：你的远程服务器 IP 地址
          * `REMOTE_USER`：登录远程服务器的用户名
          * `REMOTE_SSH_KEY`：你的远程服务器私钥，用于 SSH 免密登录。

-----

### 第二步：修改 CI/CD 配置文件

现在，我们将修改之前的 `.github/workflows/main.yml` 文件，添加构建和部署步骤。

```yaml
# .github/workflows/main.yml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    - name: Run tests
      run: pytest

  deploy:
    # 只有当 'build-and-test' 任务成功时才运行
    needs: build-and-test
    runs-on: ubuntu-latest

    steps:
      # 步骤1: 检出代码
      - uses: actions/checkout@v3

      # 步骤2: 登录 Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # 步骤3: 构建并推送 Docker 镜像
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/your-repo-name:latest # 替换 'your-repo-name' 为你的镜像名称

      # 步骤4: 通过 SSH 部署到远程服务器
      - name: Deploy to Server via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.REMOTE_HOST }}
          username: ${{ secrets.REMOTE_USER }}
          key: ${{ secrets.REMOTE_SSH_KEY }}
          script: |
            # 登录 Docker Hub (在服务器端)
            docker login -u ${{ secrets.DOCKERHUB_USERNAME }} -p ${{ secrets.DOCKERHUB_TOKEN }}

            # 拉取最新的 Docker 镜像
            docker pull ${{ secrets.DOCKERHUB_USERNAME }}/your-repo-name:latest

            # 停止并删除旧的容器
            docker stop my-app || true
            docker rm my-app || true

            # 启动新的容器
            docker run -d --name my-app ${{ secrets.DOCKERHUB_USERNAME }}/your-repo-name:latest
```

**重点解释**：

  * **`needs: build-and-test`**：这行代码非常重要，它确保只有当 `build-and-test` 任务（即 CI 流程）成功通过后，`deploy` 任务才会运行。这实现了\*\*“只有高质量的代码才能被部署”\*\*的原则。
  * **`docker/login-action@v2`** 和 **`docker/build-push-action@v4`**：这些是 GitHub Actions 的官方插件，可以简化 Docker 的构建和推送过程。
  * **`appleboy/ssh-action@master`**：这是一个常用的第三方插件，用于通过 SSH 连接到远程服务器并执行命令。
  * **`script`**：在远程服务器上执行的 Shell 命令。它会拉取最新的镜像，停止并删除旧容器，然后用最新镜像启动一个新容器。

-----

### 第三步：体验完整的 CI/CD 流程

现在，你只需要重复之前的操作，修改并提交代码到 `main` 分支。

1.  **在本地修改 `app.py`**：例如，修改 `print` 语句。
    ```python
    # app.py
    # ...
    if __name__ == '__main__':
        print(f"1 + 2 = {add(1, 2)}")
        print("Hello, CI/CD!")
    ```
2.  **提交并推送到 GitHub**：
    ```bash
    git add .
    git commit -m "feat: complete CI/CD setup"
    git push origin main
    ```

**观察结果**：

  * 在 GitHub Actions 页面，你会看到一个全新的工作流被触发。
  * 首先，`build-and-test` 任务会运行，执行测试。
  * 如果测试通过，`deploy` 任务会自动开始。
  * 部署任务会构建 Docker 镜像，推送到 Docker Hub，然后通过 SSH 连接到你的远程服务器，并自动部署新版本的应用。

**恭喜你！** 你现在拥有了一个完整的 CI/CD 自动化流水线。当你有任何代码变更时，它都会自动进行**集成、测试、打包和部署**，大大提高了开发效率和可靠性。

如果你在实践过程中遇到任何问题，可以随时提问。
