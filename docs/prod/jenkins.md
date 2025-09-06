# k3s 部署 Jenkins

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
