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
