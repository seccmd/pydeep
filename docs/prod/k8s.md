# K8S

```
Kubernetes 集群
├── **Control Plane（k8s server）**：集群大脑
│   ├── API Server（k8s 总入口）
│   ├── Scheduler（调度 Pod 到 Node）
│   ├── Controller Manager（维护集群状态）
│   └── etcd（存储集群数据）
│
└── **Worker Nodes（工作节点）**：运行实际负载
  ├── **kubelet**（节点上的 "Pod 管家"）
  ├── **kube-proxy**（k8s agent，管理网络规则）
  ├── **Pod**（容器组，运行在 Node 上）
  └── **容器运行时**（如 Docker/Containerd）
```
