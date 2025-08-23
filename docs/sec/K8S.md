[TOC]

# TODO

学习资源梳理
k8s in action 书籍
今天学习的小教程
网络文章
阿里云/腾讯云 文档和服务尝试

k8s auth 原理
k8s auth 攻击面分析
k8s auth km泄露利用
k8s 网络和系统风险

阿里云创建一个k8s实例，基操测试 RBAC测试

专题：K8S网络和系统攻击面

实战应用: km泄露攻击面分析


https://learnk8s.io/microservices-authentication-kubernetes

https://wiki.teamssix.com/

[https://wiki.teamssix.com/CloudService/](https://wiki.teamssix.com/)



# k8s技术大纲

\# 目的

\- 概念，价值作用，Demo体验，功能使用，应用场景

\## kubectl 

\- Kubernetes 命令行工具，kubectl，使得你可以对 Kubernetes 集群运行命令。 你可以使用 kubectl 来部署应用、监测和管理集群资源以及查看日志。

\- https://kubernetes.io/zh/docs/tasks/tools/

\## 学习环境

minikube: https://minikube.sigs.k8s.io/docs/start/

\- kind todo?

\- kubeadm todo?

# k8s测试环境

VPS

```
测试环境选择。
hk ok
47.243.50.12

vm ok
192.168.208.132

ESXi ok
VPS：使用部门内部的虚拟化平台
+1.网络通道主机，堡垒机，公网访问ssh
ssh -oPort=3022  sysadmin@192.168.251.37

k8s-master 
sysadmin@192.168.99.105

k8s-node1
```

## minikube

### ~/.kube/config

```yaml
cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/sysadmin/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Tue, 31 May 2022 20:03:10 PDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Tue, 31 May 2022 20:03:10 PDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /home/sysadmin/.minikube/profiles/minikube/client.crt
    client-key: /home/sysadmin/.minikube/profiles/minikube/client.key
```

### ~/.minikube

ca.crt ca.key
```bash
$ openssl rsa -noout -text -in ca.key
RSA Private-Key: (2048 bit, 2 primes)

$ openssl x509 -noout -text -in ca.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = minikubeCA
        Validity
            Not Before: May 19 11:42:15 2022 GMT
            Not After : May 17 11:42:15 2032 GMT
        Subject: CN = minikubeCA
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:c7:37:2f:3d:61:97:6f:c2:c3:53:1e:5c:7b:18:
                    d2:21:9b:7c:9c:a6:b7:fd:9f:14:18:71:ac:3d:15:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Certificate Sign
            X509v3 Extended Key Usage:
                TLS Web Client Authentication, TLS Web Server Authentication
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                C8:50:D1:5D:44:09:A1:04:9E:9B:F6:E1:D2:5A:8A:40:91:5D:30:BB
    Signature Algorithm: sha256WithRSAEncryption
         b8:b9:23:fb:fc:86:4b:22:74:a9:f4:70:3c:ca:2b:fc:50:dd:
         aa:37:c9:e1:91:4b:63:d9:7e:5c:58:6f:67:88:6b:66:21:b6:
```


proxy-client-ca.crt proxy-client-ca.key
```bash
$ openssl rsa -noout -text -in proxy-client-ca.key
RSA Private-Key: (2048 bit, 2 primes)

$ openssl x509 -noout -text -in proxy-client-ca.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = proxyClientCA
        Validity
            Not Before: May 19 11:42:16 2022 GMT
            Not After : May 17 11:42:16 2032 GMT
        Subject: CN = proxyClientCA
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:fe:27:a6:61:64:33:e9:8e:41:84:d4:26:3e:1a:
                    95:86:9b:b1:92:60:5d:5a:c7:25:13:89:70:40:63:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Certificate Sign
            X509v3 Extended Key Usage:
                TLS Web Client Authentication, TLS Web Server Authentication
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                00:55:11:53:2C:40:75:C3:52:04:96:84:4C:01:C2:30:9C:E7:22:F4
    Signature Algorithm: sha256WithRSAEncryption
         03:1e:af:40:be:c6:20:a9:fb:9c:9d:3c:49:46:0f:43:43:10:
         10:95:33:1a:27:fd:0e:b4:8e:9b:f9:a2:78:86:b8:1a:49:cb:
```

### ~/.minikube/profiles/minikube

apiserver.crt
apiserver.key

```
$ openssl x509 -noout -text -in apiserver.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 2 (0x2)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = minikubeCA
        Validity
            Not Before: May 19 11:42:16 2022 GMT
            Not After : May 19 11:42:16 2025 GMT
        Subject: O = system:masters, CN = minikube
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:eb:0f:47:fb:22:a9:b3:50:df:40:39:88:33:3f:
                    5c:1b:01:01:a3:d5:4b:16:f7:bc:6b:21:2e:8e:63:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:C8:50:D1:5D:44:09:A1:04:9E:9B:F6:E1:D2:5A:8A:40:91:5D:30:BB

            X509v3 Subject Alternative Name:
                DNS:minikubeCA, DNS:control-plane.minikube.internal, DNS:kubernetes.default.svc.cluster.local, DNS:kubernetes.default.svc, DNS:kubernetes.default, DNS:kubernetes, DNS:localhost, IP Address:192.168.49.2, IP Address:10.96.0.1, IP Address:127.0.0.1, IP Address:10.0.0.1

    Signature Algorithm: sha256WithRSAEncryption
         30:63:35:5b:ff:d3:44:77:94:4b:33:35:39:15:7e:5b:5c:f5:
         56:15:ee:6b:e9:a7:03:bf:fc:66:69:d6:f4:b0:86:59:89:19:

```

apiserver.crt.dd3b5fb2
apiserver.key.dd3b5fb2
```
$ openssl x509 -noout -text -in apiserver.crt.dd3b5fb2
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 2 (0x2)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = minikubeCA
        Validity
            Not Before: May 19 11:42:16 2022 GMT
            Not After : May 19 11:42:16 2025 GMT
        Subject: O = system:masters, CN = minikube
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:eb:0f:47:fb:22:a9:b3:50:df:40:39:88:33:3f:
                    5c:1b:01:01:a3:d5:4b:16:f7:bc:6b:21:2e:8e:63:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:C8:50:D1:5D:44:09:A1:04:9E:9B:F6:E1:D2:5A:8A:40:91:5D:30:BB

            X509v3 Subject Alternative Name:
                DNS:minikubeCA, DNS:control-plane.minikube.internal, DNS:kubernetes.default.svc.cluster.local, DNS:kubernetes.default.svc, DNS:kubernetes.default, DNS:kubernetes, DNS:localhost, IP Address:192.168.49.2, IP Address:10.96.0.1, IP Address:127.0.0.1, IP Address:10.0.0.1

    Signature Algorithm: sha256WithRSAEncryption
         30:63:35:5b:ff:d3:44:77:94:4b:33:35:39:15:7e:5b:5c:f5:
         56:15:ee:6b:e9:a7:03:bf:fc:66:69:d6:f4:b0:86:59:89:19:

```


proxy-client.crt
proxy-client.key
```
$ openssl x509 -noout -text -in proxy-client.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 2 (0x2)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = proxyClientCA
        Validity
            Not Before: May 19 11:42:17 2022 GMT
            Not After : May 19 11:42:17 2025 GMT
        Subject: O = system:masters, CN = aggregator
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:c9:01:f5:1e:1c:77:b8:74:62:c3:0b:e0:7b:1f:
                    a0:f1:3b:6a:c5:b0:8b:ee:87:8d:68:62:3d:33:9f:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:00:55:11:53:2C:40:75:C3:52:04:96:84:4C:01:C2:30:9C:E7:22:F4

    Signature Algorithm: sha256WithRSAEncryption
         dd:af:81:df:e1:6a:b7:c3:e3:70:2f:01:3e:66:3e:86:56:9d:
         10:c0:b0:26:38:65:ef:71:35:b6:1b:56:bd:a0:c7:c8:3b:12:
```


client.crt
client.key

```
$ openssl x509 -noout -text -in client.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 2 (0x2)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = minikubeCA
        Validity
            Not Before: May 19 11:42:16 2022 GMT
            Not After : May 19 11:42:16 2025 GMT
        Subject: O = system:masters, CN = minikube-user
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:96:1e:9a:b8:87:ca:73:4a:de:10:dc:76:45:0f:
                    e2:37:0b:b0:e0:68:97:d0:a7:2d:14:9a:e2:59:5b:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:C8:50:D1:5D:44:09:A1:04:9E:9B:F6:E1:D2:5A:8A:40:91:5D:30:BB

    Signature Algorithm: sha256WithRSAEncryption
         41:d4:f8:2f:4d:34:6f:f2:b1:2d:a0:09:eb:70:b6:57:a7:3c:
         7b:47:4c:f7:41:ef:d8:07:6e:6e:48:4c:36:c3:e6:ff:0e:b4:

```


config.json
```
{
        "Name": "minikube",
        "KeepContext": false,
        "EmbedCerts": false,
        "MinikubeISO": "",
        "KicBaseImage": "gcr.io/k8s-minikube/kicbase:v0.0.30@sha256:02c921df998f95e849058af14de7045efc3954d90320967418a0d1f182bbc0b2",
        "Memory": 2200,
        "CPUs": 2,
        "DiskSize": 20000,
        "VMDriver": "",
        "Driver": "docker",
        "HyperkitVpnKitSock": "",
        "HyperkitVSockPorts": [],
        "DockerEnv": null,
        "ContainerVolumeMounts": null,
        "InsecureRegistry": null,
        "RegistryMirror": [],
        "HostOnlyCIDR": "192.168.59.1/24",
        "HypervVirtualSwitch": "",
        "HypervUseExternalSwitch": false,
        "HypervExternalAdapter": "",
        "KVMNetwork": "default",
        "KVMQemuURI": "qemu:///system",
        "KVMGPU": false,
        "KVMHidden": false,
        "KVMNUMACount": 1,
        "DockerOpt": null,
        "DisableDriverMounts": false,
        "NFSShare": [],
        "NFSSharesRoot": "/nfsshares",
        "UUID": "",
        "NoVTXCheck": false,
        "DNSProxy": false,
        "HostDNSResolver": true,
        "HostOnlyNicType": "virtio",
        "NatNicType": "virtio",
        "SSHIPAddress": "",
        "SSHUser": "root",
        "SSHKey": "",
        "SSHPort": 22,
        "KubernetesConfig": {
                "KubernetesVersion": "v1.23.3",
                "ClusterName": "minikube",
                "Namespace": "default",
                "APIServerName": "minikubeCA",
                "APIServerNames": null,
                "APIServerIPs": null,
                "DNSDomain": "cluster.local",
                "ContainerRuntime": "docker",
                "CRISocket": "",
                "NetworkPlugin": "",
                "FeatureGates": "",
                "ServiceCIDR": "10.96.0.0/12",
                "ImageRepository": "",
                "LoadBalancerStartIP": "",
                "LoadBalancerEndIP": "",
                "CustomIngressCert": "",
                "ExtraOptions": [
                        {
                                "Component": "kubelet",
                                "Key": "housekeeping-interval",
                                "Value": "5m"
                        }
                ],
                "ShouldLoadCachedImages": true,
                "EnableDefaultCNI": false,
                "CNI": "",
                "NodeIP": "",
                "NodePort": 8443,
                "NodeName": ""
        },
        "Nodes": [
                {
                        "Name": "",
                        "IP": "192.168.49.2",
                        "Port": 8443,
                        "KubernetesVersion": "v1.23.3",
                        "ContainerRuntime": "docker",
                        "ControlPlane": true,
                        "Worker": true
                }
        ],
        "Addons": {
                "ambassador": false,
                "auto-pause": false,
                "csi-hostpath-driver": false,
                "dashboard": true,
                "default-storageclass": true,
                "efk": false,
                "freshpod": false,
                "gcp-auth": false,
                "gvisor": false,
                "helm-tiller": false,
                "ingress": false,
                "ingress-dns": false,
                "istio": false,
                "istio-provisioner": false,
                "kong": false,
                "kubevirt": false,
                "logviewer": false,
                "metallb": false,
                "metrics-server": false,
                "nvidia-driver-installer": false,
                "nvidia-gpu-device-plugin": false,
                "olm": false,
                "pod-security-policy": false,
                "portainer": false,
                "registry": false,
                "registry-aliases": false,
                "registry-creds": false,
                "storage-provisioner": true,
                "storage-provisioner-gluster": false,
                "volumesnapshots": false
        },
        "CustomAddonImages": null,
        "CustomAddonRegistries": null,
        "VerifyComponents": {
                "apiserver": true,
                "system_pods": true
        },
        "StartHostTimeout": 360000000000,
        "ScheduledStop": null,
        "ExposedPorts": [],
        "ListenAddress": "",
        "Network": "",
        "MultiNodeRequested": false,
        "ExtraDisks": 0,
        "CertExpiration": 94608000000000000,
        "Mount": false,
        "MountString": "/home/sysadmin:/minikube-host",
        "Mount9PVersion": "9p2000.L",
        "MountGID": "docker",
        "MountIP": "",
        "MountMSize": 262144,
        "MountOptions": [],
        "MountPort": 0,
        "MountType": "9p",
        "MountUID": "docker",
        "BinaryMirror": "",
        "DisableOptimizations": false
}
```

events.json
```
$ cat events.json
{"specversion":"1.0","id":"941d8486-a020-437d-a424-63fe3b3bb3d1","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"0","message":"😄  minikube v1.25.2 on Ubuntu 20.04","name":"Initial Minikube Setup","totalsteps":"19"}}
{"specversion":"1.0","id":"4796cfa3-b617-4b73-bfe0-92f72e683adf","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"1","message":"✨  Using the docker driver based on existing profile","name":"Selecting Driver","totalsteps":"19"}}
{"specversion":"1.0","id":"cbb48ccb-0ba0-4f32-9a7e-991b6b85f703","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"3","message":"👍  Starting control plane node minikube in cluster minikube","name":"Starting Node","totalsteps":"19"}}
{"specversion":"1.0","id":"51ed4e04-034f-4cbc-bca7-6a50c0723690","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"5","message":"🚜  Pulling base image ...","name":"Pulling Base Image","totalsteps":"19"}}
{"specversion":"1.0","id":"c0368e28-dbab-4425-81ee-7937acc41b27","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"5","message":"🔄  Restarting existing docker container for \"minikube\" ...","name":"Pulling Base Image","totalsteps":"19"}}
{"specversion":"1.0","id":"9c14843c-6c3d-401d-8e04-e8fd21c7486c","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.error","datacontenttype":"application/json","data":{"message":"💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/"}}
{"specversion":"1.0","id":"69b1e2ad-14fd-4394-bfcc-f8ded77a5796","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.error","datacontenttype":"application/json","data":{"message":"❗  This container is having trouble accessing https://k8s.gcr.io"}}
{"specversion":"1.0","id":"7ea69d69-f5f3-4799-bfac-4ec5518dd48b","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"11","message":"🐳  Preparing Kubernetes v1.23.3 on Docker 20.10.12 ...","name":"Preparing Kubernetes","totalsteps":"19"}}
{"specversion":"1.0","id":"416e5f68-7a9d-4d4e-b2bf-cd592de3820e","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"17","message":"🔎  Verifying Kubernetes components...","name":"Verifying Kubernetes","totalsteps":"19"}}
{"specversion":"1.0","id":"0cdd5179-f278-4f69-970b-d106fe08cc77","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"18","message":"🌟  Enabled addons: default-storageclass, storage-provisioner, dashboard","name":"Enabling Addons","totalsteps":"19"}}
{"specversion":"1.0","id":"f73dc005-c870-49f6-bfa1-78903dd0be1a","source":"https://minikube.sigs.k8s.io/","type":"io.k8s.sigs.minikube.step","datacontenttype":"application/json","data":{"currentstep":"19","message":"🏄  Done! kubectl is now configured to use \"minikube\" cluster and \"default\" namespace by default","name":"Done","totalsteps":"19"}}
```

### ~/.minikube/machines

```
$ ls minikube/
config.json  id_rsa  id_rsa.pub
```

server-key.pem  
```
$ openssl rsa -noout -text -in server-key.pem
RSA Private-Key: (2048 bit, 2 primes)
```

server.pem
```
$ openssl x509 -noout -text -in server.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            2e:51:38:34:b0:3b:ea:cc:9a:50:fa:6d:49:ad:1a:99
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: O = sysadmin
        Validity
            Not Before: Jun  1 02:57:00 2022 GMT
            Not After : May 16 02:57:00 2025 GMT
        Subject: O = sysadmin.minikube
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:d8:bf:45:a3:24:29:6e:37:9c:80:b8:23:68:a1:
                    35:af:69:65:10:3c:52:4d:af:64:15:bd:c3:e4:fa:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Key Agreement
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:C6:05:49:55:04:12:FD:E7:66:9B:C4:53:D1:54:1D:26:DD:95:D8:D5

            X509v3 Subject Alternative Name:
                DNS:localhost, DNS:minikube, DNS:minikube, IP Address:192.168.49.2, IP Address:127.0.0.1, IP Address:127.0.0.1
    Signature Algorithm: sha256WithRSAEncryption
         d2:20:e3:0a:62:82:a4:41:71:79:bf:ff:03:4b:88:ca:71:d9:
         93:f1:88:2b:73:1b:55:7b:2d:e6:ff:38:38:de:c7:0d:ed:12:

```

config.json
```
$ cat minikube/config.json
{
    "ConfigVersion": 3,
    "Driver": {
        "IPAddress": "",
        "MachineName": "minikube",
        "SSHUser": "",
        "SSHPort": 0,
        "SSHKeyPath": "/home/sysadmin/.minikube/machines/minikube/id_rsa",
        "StorePath": "/home/sysadmin/.minikube",
        "SwarmMaster": false,
        "SwarmHost": "",
        "SwarmDiscovery": "",
        "URL": "",
        "NodeConfig": {
            "ClusterName": "minikube",
            "MachineName": "minikube",
            "CPU": 2,
            "Memory": 2200,
            "StorePath": "/home/sysadmin/.minikube",
            "OCIBinary": "docker",
            "ImageDigest": "gcr.io/k8s-minikube/kicbase:v0.0.30@sha256:02c921df998f95e849058af14de7045efc3954d90320967418a0d1f182bbc0b2",
            "Mounts": [],
            "APIServerPort": 8443,
            "PortMappings": null,
            "Envs": null,
            "KubernetesVersion": "v1.23.3",
            "ContainerRuntime": "docker",
            "Network": "",
            "ExtraArgs": [],
            "ListenAddress": ""
        },
        "OCIBinary": "docker"
    },
    "DriverName": "docker",
    "HostOptions": {
        "Driver": "",
        "Memory": 0,
        "Disk": 0,
        "EngineOptions": {
            "ArbitraryFlags": null,
            "Dns": null,
            "GraphDir": "",
            "Env": [
                "HTTP_PROXY=http://192.168.208.128:808/",
                "HTTPS_PROXY=http://192.168.208.128:808/",
                "NO_PROXY=localhost,127.0.0.0/8,::1"
            ],
            "Ipv6": false,
            "InsecureRegistry": [
                "10.96.0.0/12"
            ],
            "Labels": null,
            "LogLevel": "",
            "StorageDriver": "",
            "SelinuxEnabled": false,
            "TlsVerify": false,
            "RegistryMirror": [],
            "InstallURL": "https://get.docker.com"
        },
        "SwarmOptions": {
            "IsSwarm": false,
            "Address": "",
            "Discovery": "",
            "Agent": false,
            "Master": false,
            "Host": "",
            "Image": "",
            "Strategy": "",
            "Heartbeat": 0,
            "Overcommit": 0,
            "ArbitraryFlags": null,
            "ArbitraryJoinFlags": null,
            "Env": null,
            "IsExperimental": false
        },
        "AuthOptions": {
            "CertDir": "/home/sysadmin/.minikube",
            "CaCertPath": "/home/sysadmin/.minikube/certs/ca.pem",
            "CaPrivateKeyPath": "/home/sysadmin/.minikube/certs/ca-key.pem",
            "CaCertRemotePath": "",
            "ServerCertPath": "/home/sysadmin/.minikube/machines/server.pem",
            "ServerKeyPath": "/home/sysadmin/.minikube/machines/server-key.pem",
            "ClientKeyPath": "/home/sysadmin/.minikube/certs/key.pem",
            "ServerCertRemotePath": "",
            "ServerKeyRemotePath": "",
            "ClientCertPath": "/home/sysadmin/.minikube/certs/cert.pem",
            "ServerCertSANs": null,
            "StorePath": "/home/sysadmin/.minikube"
        }
    },
    "Name": "minikube"
}
```

### ~/.minikube/certs

ca.pem ca-key.pem

```
$ openssl rsa -noout -text -in ca-key.pem
RSA Private-Key: (2048 bit, 2 primes)

$ openssl x509 -noout -text -in ca.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            1a:10:88:42:3d:f9:f5:f4:ba:00:c1:7d:c6:b2:df:89
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: O = sysadmin
        Validity
            Not Before: May 20 10:39:00 2022 GMT
            Not After : May  4 10:39:00 2025 GMT
        Subject: O = sysadmin
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:e7:67:d5:6f:61:f4:06:00:18:e8:d0:21:16:1f:
                    f7:c7:04:7a:86:0f:9d:9a:2e:06:e3:13:78:d6:c5:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Key Agreement, Certificate Sign
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                C6:05:49:55:04:12:FD:E7:66:9B:C4:53:D1:54:1D:26:DD:95:D8:D5
    Signature Algorithm: sha256WithRSAEncryption
         26:ac:bd:a9:10:4a:6b:07:34:f1:f2:d2:7e:52:a2:98:79:1b:
         74:8a:8c:c4:f1:01:99:fb:ad:d0:1b:8c:de:28:ce:7c:95:93:

```

cert.pem
```
$ openssl x509 -noout -text -in cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            90:5f:35:cd:16:bc:f2:50:1a:a8:73:e1:ff:df:bc:e8
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: O = sysadmin
        Validity
            Not Before: May 20 10:39:00 2022 GMT
            Not After : May  4 10:39:00 2025 GMT
        Subject: O = "sysadmin.<bootstrap>"
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:be:c3:28:eb:fc:dd:98:40:9f:1f:8e:33:18:96:
                    43:ba:2a:a4:10:1c:36:1d:1c:08:0c:41:d2:d4:8d:
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature
            X509v3 Extended Key Usage:
                TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:C6:05:49:55:04:12:FD:E7:66:9B:C4:53:D1:54:1D:26:DD:95:D8:D5

    Signature Algorithm: sha256WithRSAEncryption
         0e:4a:3a:f4:64:07:86:93:dd:87:2e:c6:2a:2d:2d:19:ad:07:
         a3:49:13:75:8f:27:91:3f:7f:e4:2d:d1:ed:25:b6:bd:3b:11:

```

key.pem

```
$ openssl rsa -noout -text -in key.pem
RSA Private-Key: (2048 bit, 2 primes)
```

## kubeadm

### Install

````markdown
# 目的
- 概念，价值作用，Demo体验，功能使用，应用场景

## kubectl 

- Kubernetes 命令行工具，kubectl，使得你可以对 Kubernetes 集群运行命令。 使用 kubectl 来部署应用、监测和管理集群资源以及查看日志。
- https://kubernetes.io/zh/docs/tasks/tools/

## 学习环境
minikube: https://minikube.sigs.k8s.io/docs/start/
- kind todo?
- kubeadm todo?

安装成功:
Your Kubernetes control-plane has initialized successfully!
To start using your cluster, you need to run the following as a regular user:
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
Alternatively, if you are the root user, you can run:
  export KUBECONFIG=/etc/kubernetes/admin.conf
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/
Then you can join any number of worker nodes by running the following on each as root:
kubeadm join 192.168.99.105:6443 --token uhe2lm.m79z6udzxhsw91o8 \
        --discovery-token-ca-cert-hash sha256:c32e6bceb0347e0239ffe2c1e8333eb49b9ca771af2c6b5802e9683d7d271813
		This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.
Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

## 报错问题

版本太低报错
国外镜像无法下载，临时使用expressVPN

kubeadm init 假的源--image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.24.0 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
kubeadm init --apiserver-advertise-address=192.168.99.105 --kubernetes-version v1.24.0 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
kubeadm init --apiserver-advertise-address=192.168.99.105 --pod-network-cidr=10.244.0.0/16

**kubeadm init 报错 ”unknown service runtime.v1alpha2.RuntimeService”**
 [ERROR CRI]: container runtime is not running
解决：
[root@k8s-master opt]# rm /etc/containerd/config.toml 
[root@k8s-master opt]# systemctl restart containerd

**Kubernetes报错：The kubelet is not running**
https://blog.csdn.net/qq_33326449/article/details/119699126
查看官网介绍为 docker 和 kubelet 服务中的 cgroup 驱动不一致，
```
root@controlplane:~# cat /etc/docker/daemon.json 
{
  "exec-opts": [
    "native.cgroupdriver=systemd"
  ]
}
```

**kubeadm init 失败后回滚，重新安**
https://blog.imdst.com/kubernetes-k8s-kubeadm-init-shi-bai-de-jie-jue-fang-fa/
kubeadm reset
k8s删除node节点
https://blog.csdn.net/m0_60496726/article/details/120782349
````

### Kubeadm

```bash
1.系统配置
2.软件源头
- apt国内源
- Docker-CE 国内
- kubernetes源
# Debian/Ubuntu
apt-get update && apt-get install -y apt-transport-https
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg| apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```



# kubectl 功能和服务

## 账号和组

```markdown
##### 认证方式
*目前有几个认证插件是直接可用的。它们使用下列方法获取客户端的身份认证： *
- 客户端证书
- 传入在 HTTP 头中的认证 token
- 基础的 HTTP 认证
- 其他

##### 用户类型
*Kubernetes 区分 了两种连接到 PI 服务器的客户端*
- 真实的人 （用户）
- 服务账号 （更准确地说是运行在 pod 中的应用）

##### 用户组
*正常用户和 ServiceAccount 都可 属于一个或多个组。 *

- system unauthenticated 组用于所有认证插件都不会认证客户端身份的
请求。
- system authent cated 组会自动分配给一个成功通过认证的用户。
- system:serviceaccounts 组包含所有在系统中的 Serv iceAccount。
- system:serviceaccounts:<namespace>组包含了所有在特定命名空间中的ServiceAccount。
```



## API 功能

```bash
$ curl --cacert /home/sysadmin/.minikube/ca.crt --key /home/sysadmin/.minikube/profiles/minikube/client.key --cert /home/sysadmin/.minikube/profiles/minikube/client.crt https://192.168.49.2:8443/api/

$ curl --cacert /home/sysadmin/.minikube/ca.crt --key /home/sysadmin/.minikube/profiles/minikube/client.key --cert /home/sysadmin/.minikube/profiles/minikube/client.crt https://192.168.49.2:8443/api/v1/namespaces/default/pods

$ kubectl api-resources
NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
bindings                                       v1                                     true         Binding
componentstatuses                 cs           v1                                     false        ComponentStatus
configmaps                        cm           v1                                     true         ConfigMap
endpoints                         ep           v1                                     true         Endpoints
events                            ev           v1                                     true         Event
limitranges                       limits       v1                                     true         LimitRange
namespaces                        ns           v1                                     false        Namespace
nodes                             no           v1                                     false        Node
persistentvolumeclaims            pvc          v1                                     true         PersistentVolumeClaim
persistentvolumes                 pv           v1                                     false        PersistentVolume
pods                              po           v1                                     true         Pod
podtemplates                                   v1                                     true         PodTemplate
replicationcontrollers            rc           v1                                     true         ReplicationController
resourcequotas                    quota        v1                                     true         ResourceQuota
secrets                                        v1                                     true         Secret
serviceaccounts                   sa           v1                                     true         ServiceAccount
services                          svc          v1                                     true         Service
mutatingwebhookconfigurations                  admissionregistration.k8s.io/v1        false        MutatingWebhookConfiguration
validatingwebhookconfigurations                admissionregistration.k8s.io/v1        false        ValidatingWebhookConfiguration
customresourcedefinitions         crd,crds     apiextensions.k8s.io/v1                false        CustomResourceDefinition
apiservices                                    apiregistration.k8s.io/v1              false        APIService
controllerrevisions                            apps/v1                                true         ControllerRevision
daemonsets                        ds           apps/v1                                true         DaemonSet
deployments                       deploy       apps/v1                                true         Deployment
replicasets                       rs           apps/v1                                true         ReplicaSet
statefulsets                      sts          apps/v1                                true         StatefulSet
tokenreviews                                   authentication.k8s.io/v1               false        TokenReview
localsubjectaccessreviews                      authorization.k8s.io/v1                true         LocalSubjectAccessReview
selfsubjectaccessreviews                       authorization.k8s.io/v1                false        SelfSubjectAccessReview
selfsubjectrulesreviews                        authorization.k8s.io/v1                false        SelfSubjectRulesReview
subjectaccessreviews                           authorization.k8s.io/v1                false        SubjectAccessReview
horizontalpodautoscalers          hpa          autoscaling/v2                         true         HorizontalPodAutoscaler
cronjobs                          cj           batch/v1                               true         CronJob
jobs                                           batch/v1                               true         Job
certificatesigningrequests        csr          certificates.k8s.io/v1                 false        CertificateSigningRequest
leases                                         coordination.k8s.io/v1                 true         Lease
endpointslices                                 discovery.k8s.io/v1                    true         EndpointSlice
events                            ev           events.k8s.io/v1                       true         Event
flowschemas                                    flowcontrol.apiserver.k8s.io/v1beta2   false        FlowSchema
prioritylevelconfigurations                    flowcontrol.apiserver.k8s.io/v1beta2   false        PriorityLevelConfiguration
ingressclasses                                 networking.k8s.io/v1                   false        IngressClass
ingresses                         ing          networking.k8s.io/v1                   true         Ingress
networkpolicies                   netpol       networking.k8s.io/v1                   true         NetworkPolicy
runtimeclasses                                 node.k8s.io/v1                         false        RuntimeClass
poddisruptionbudgets              pdb          policy/v1                              true         PodDisruptionBudget
podsecuritypolicies               psp          policy/v1beta1                         false        PodSecurityPolicy
clusterrolebindings                            rbac.authorization.k8s.io/v1           false        ClusterRoleBinding
clusterroles                                   rbac.authorization.k8s.io/v1           false        ClusterRole
rolebindings                                   rbac.authorization.k8s.io/v1           true         RoleBinding
roles                                          rbac.authorization.k8s.io/v1           true         Role
priorityclasses                   pc           scheduling.k8s.io/v1                   false        PriorityClass
csidrivers                                     storage.k8s.io/v1                      false        CSIDriver
csinodes                                       storage.k8s.io/v1                      false        CSINode
csistoragecapacities                           storage.k8s.io/v1beta1                 true         CSIStorageCapacity
storageclasses                    sc           storage.k8s.io/v1                      false        StorageClass
volumeattachments                              storage.k8s.io/v1                      false        VolumeAttachment
```



## ServiceAccount 功能

**ServiceAccount介绍**

默认服务账号 /var/run/secrets/kubernetes.io/serviceaccount/token文件内容来进行身份认证的 。
token文件持有ServiceAccount的认证token。 应用程序使用这个 token连接API服务器时， 身份认证插件会对ServiceAccount进行身份认证， 并将 Set-viceAccount的用户名传回API服务器 内部。

ServiceAccount用户名的格式像下面这样：
```
system:serviceaccount:<namespace>:<service account name>
```

**ServiceAccount列表：**

```
$ kubectl get sa
$ kubectl get serviceaccount
$ kubectl get serviceaccount --namespace system-
```

**ServiceAccount新建：**

```
$ kubectl create serviceaccount foo

$ kubectl describe sa foo
Name:                foo
Namespace:           default
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>            # 自动地添加到使用这个serviceaccount的所有pod中
Mountable secrets:   foo-token-qk8bw   # 如果强制使用可挂在的密钥，使用这个serviceaccount的pod只能挂在这些密钥
Tokens:              foo-token-qk8bw   # 认证token，第一个token挂载在容器内
Events:              <none>
```

**ServiceAccount令牌：**

*注意你可能已经了解过JSON Web Token (JWT)。ServiceAccount中使用的身份认证token就是JWT token 。*
```
$ kubectl describe secret foo-token-qk8bw

Name:         foo-token-qk8bw
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: foo
              kubernetes.io/service-account.uid: 2ea8d040-e226-44fc-9eaf-1493d3ed5748
Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1111 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImRFckJKMmJ2WDR6RmVTR3VGajZINnAtelJKRzAzalc0M1p
```

**将 ServiceAccount 分配给 pod**

*在创建另外的 ServiceAccount 之后，需要将它们赋值给 pod。通过在 pod定义文件中的 spec.serviceAccountNarne 字段上设置 ServiceAccount的名称来进行分配。*

```
apiVersion: vl 
kind: Pod 
metadata: 
  name: curl-custom-sa
spec: 
  serviceAccountName: foo           # 这个pod使用foo ServiceAccount，而不是默认的 ServiceAccount
  containers: 
  - name: main
    image: tutum/curl
    command: ["sleep", "9999999"] 
  - name: ambassador 
    image: luksa/kubectl-proxy:l.6.2 

```

**查看挂载进pod容器内的token**

```
$ kubectl exec -it curl-cuetom-sa -c main cat /var/run/secrets/kubernetes.io/serviceaccount/token
> eyJhbGciOiJSUzI1NiisinR5cCI6IkpXVCJ9 ... 
```

**使用自定义的ServiceAccount token和API服务器进行通信**

BUG：只是一个demo，没有实际测试，实际使用需要 curl指定token
```
$ kubectl exec -it curl-custom-sa -c main curl localhost:8001/api/vl/pods
```



## RBAC 功能

### RBAC 授权

###### 介绍RBAC授权插件

Kubernetes API 服务器可以配置使用 一个授权插件来检查是否允许用户请求的
动作执行。 因为 API 服务器对外暴露了 REST 接口， 用户可以通过向服务器发送
HTTP 请求来执行动作， 通过在请求中包含认证凭证来进行认证（认证 token、 用户
名和密码或者客户端证书）

###### 了解 RBAC 插件

顾名思义， RBAC 授权插件将用户角色作为决定用户能否执行操作的关键因素。
主体（可以是一个人、 一个 ServiceAccount, 或者一组用户或 ServiceAccount)和 一
个或多个角色相关联， 每个角色被允许在特定的资源上执行特定的动词。
如果一个用户有多个角色， 他们可以做任何他们的角色允许他们做的事情。 如
果用户的角色都没有包含对应的权限， 例如， 更新密钥， API 服务器会阻止用户 3
个“他的” 对密钥执行PUT或PATCH请求

###### 介绍RBAC资源

RBAC 授权规则是通过四种资源来进行配置的， 它们可以分为两个组
• Role( 角色）和 ClusterRole (集群角色）， 它们指定了在资源上可以执行哪些动词。
• RoleBinding (角色绑定） 和 ClusterRoleBinding (集群角色绑定）， 它们将上述角色绑定到特定的用户、 组或 ServiceAccounts 上。
角色定义了可以做什么操作，而绑定定义了谁可以做这些操作

###### Role 授予权限， 同时 RoleBinding 将 Role 绑定到主体上

<img src="K8S/image-20230717122447508.png" alt="image-20230717122447508" style="zoom:50%;" />


###### 关闭基千角色的访问控制 (RBAC)

*这个命令赋予了所有服务账户（也可以说所有的pod)的集群管理员权限，允许它们执行任何需要的操作，很明显这是一个危险的操作，永远都不应该在生产的集群中执行，对于剧试来说是没有问题的。*

```
kubectl create clusterrolebinding permissive-binding\ 
--clusterrole=cluster-admin\ 
--group=system:serviceaccounts
```

###### 重新启用RBAC
```
$ kubectl delete clusterrolebinding permissive-binding 
```

### RBAC 角色Role

Role资源定义了哪些操作可以在哪些资源上执行

Role列表：
```
$ kubectl get role -n kube-system

NAME                                             CREATED AT
extension-apiserver-authentication-reader        2022-05-20T11:43:21Z
kube-proxy                                       2022-05-20T11:43:24Z
kubeadm:kubelet-config-1.23                      2022-05-20T11:43:22Z
kubeadm:nodes-kubeadm-config                     2022-05-20T11:43:22Z
system::leader-locking-kube-controller-manager   2022-05-20T11:43:21Z
system::leader-locking-kube-scheduler            2022-05-20T11:43:21Z
system:controller:bootstrap-signer               2022-05-20T11:43:21Z
system:controller:cloud-provider                 2022-05-20T11:43:21Z
system:controller:token-cleaner                  2022-05-20T11:43:21Z
system:persistent-volume-provisioner             2022-05-20T11:43:31Z

```

它允许用户获取并列出foo命名空间中的服务。

```
$ cat service-reader.yaml
apiVersion: rbac.authorization.kBs.io/vl
kind: Role 
metadata: 
  namespace: foo 
  name: service-reader 
rules: 
- apiGroups: [""]
  verbs: ["get", "list"]
  resources: ["services"]
```

现在在foo命名空间中创建先前讲的角色．
```
$ kubectl create -£ service-reader.yaml -n foo 
> role "service-reader" created 
```

命令行操作
```
$ kubectl create role service-reader --verb=get --verb=list --resource=services -n bar 
> role "service-reader" created
```



### RBAC 角色绑定RoleBinding

**绑定角色到 ServiceAccount**
角色定义了哪些操作可以执行，但没有指定谁可以执行这些操作。要做到这一
点，必须将角色绑定 一个到主体，它可以是一个user (用户）、 一个ServiceAccount或一个组（用户或 ServiceAccount 组）。

RoleBinding列表
```
$ kubectl get rolebinding -n kube-system
```

通过创建 RoleBinding 资源来实现将角色绑定到主体 运行以下命令，可
以将角色绑定到 default ServiceAccount:

```
$ kubectl create rolebinding test --role=service-reader  --serviceaccount=foo:default -n foo
```

查看yaml
```
$ kubectl get rolebinding test -n foo -o yaml 
```

注意 如果要绑定 个角色到一个 user （用户）而不是 ServiceAccount 上， 
--user 作为参数来指定用户名 
如果要绑定角色到组，可以使用 --group 参数

```
指定用户绑定权限 --user
$ kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=your.email@address.com
```

<img src="K8S/image-20230717122636110.png" alt="image-20230717122636110" style="zoom:50%;" />

获取服务
```
curl localhost : 8001/api/vl/namespaces/foo/service
```



### RBAC ClusterRole-ClusterRoleBinding

##### ClusterRole 是一种集群级资源
一些特定的资源完全不在命名空间中（包括
Node Persi tentVolume mesp ，等等）。我们也提到过 PI 服务器对外暴露了
一些不表示资源的 路径（例如／heal thz 常规角色不能对这些资源或非资
源型的 URL 进行授权，

##### 允许访问集群级别的资源
```
$ kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes 

$ kubectl get clusterrole pv-reader -o yaml 

注意 这个 URL 没有包含命名空间，因为 PersistentVolume 不在命名空间里
# curl localhost:8001/api/vl/persistentvolumes 
```


```
kubectl create rolebinding view-test --clusterrole=view --serviceaccount=default:default

kubectl create clusterrolebinding pv-test -”clusterrole=pv-reader 
--serviceaccount=foo:default 
```

##### 了解默认的 ClusterRole 和 ClusterRoleBinding
```
$ kubectl get clusterrolebindings
NAME                                                   ROLE                                                                               AGE
cluster-admin                                          ClusterRole/cluster-admin                                                          14d
kubeadm:get-nodes                                      ClusterRole/kubeadm:get-nodes                                                      14d
kubeadm:kubelet-bootstrap                              ClusterRole/system:node-bootstrapper                                               14d
kubeadm:node-autoapprove-bootstrap                     ClusterRole/system:certificates.k8s.io:certificatesigningrequests:nodeclient       14d
kubeadm:node-autoapprove-certificate-rotation          ClusterRole/system:certificates.k8s.io:certificatesigningrequests:selfnodeclient   14d
kubeadm:node-proxier                                   ClusterRole/system:node-proxier                                                    14d
kubernetes-dashboard                                   ClusterRole/cluster-admin                                                          13d
minikube-rbac                                          ClusterRole/cluster-admin                                                          14d
storage-provisioner                                    ClusterRole/system:persistent-volume-provisioner                                   14d
system:basic-user                                      ClusterRole/system:basic-user                                                      14d
system:controller:attachdetach-controller              ClusterRole/system:controller:attachdetach-controller                              14d
system:controller:certificate-controller               ClusterRole/system:controller:certificate-controller                               14d
system:controller:clusterrole-aggregation-controller   ClusterRole/system:controller:clusterrole-aggregation-controller                   14d
system:controller:cronjob-controller                   ClusterRole/system:controller:cronjob-controller                                   14d
system:controller:daemon-set-controller                ClusterRole/system:controller:daemon-set-controller                                14d
system:controller:deployment-controller                ClusterRole/system:controller:deployment-controller                                14d
system:controller:disruption-controller                ClusterRole/system:controller:disruption-controller                                14d
system:controller:endpoint-controller                  ClusterRole/system:controller:endpoint-controller                                  14d
system:controller:endpointslice-controller             ClusterRole/system:controller:endpointslice-controller                             14d
system:controller:endpointslicemirroring-controller    ClusterRole/system:controller:endpointslicemirroring-controller                    14d
system:controller:ephemeral-volume-controller          ClusterRole/system:controller:ephemeral-volume-controller                          14d
system:controller:expand-controller                    ClusterRole/system:controller:expand-controller                                    14d
system:controller:generic-garbage-collector            ClusterRole/system:controller:generic-garbage-collector                            14d
system:controller:horizontal-pod-autoscaler            ClusterRole/system:controller:horizontal-pod-autoscaler                            14d
system:controller:job-controller                       ClusterRole/system:controller:job-controller                                       14d
system:controller:namespace-controller                 ClusterRole/system:controller:namespace-controller                                 14d
system:controller:node-controller                      ClusterRole/system:controller:node-controller                                      14d
system:controller:persistent-volume-binder             ClusterRole/system:controller:persistent-volume-binder                             14d
system:controller:pod-garbage-collector                ClusterRole/system:controller:pod-garbage-collector                                14d
system:controller:pv-protection-controller             ClusterRole/system:controller:pv-protection-controller                             14d
system:controller:pvc-protection-controller            ClusterRole/system:controller:pvc-protection-controller                            14d
system:controller:replicaset-controller                ClusterRole/system:controller:replicaset-controller                                14d
system:controller:replication-controller               ClusterRole/system:controller:replication-controller                               14d
system:controller:resourcequota-controller             ClusterRole/system:controller:resourcequota-controller                             14d
system:controller:root-ca-cert-publisher               ClusterRole/system:controller:root-ca-cert-publisher                               14d
system:controller:route-controller                     ClusterRole/system:controller:route-controller                                     14d
system:controller:service-account-controller           ClusterRole/system:controller:service-account-controller                           14d
system:controller:service-controller                   ClusterRole/system:controller:service-controller                                   14d
system:controller:statefulset-controller               ClusterRole/system:controller:statefulset-controller                               14d
system:controller:ttl-after-finished-controller        ClusterRole/system:controller:ttl-after-finished-controller                        14d
system:controller:ttl-controller                       ClusterRole/system:controller:ttl-controller                                       14d
system:coredns                                         ClusterRole/system:coredns                                                         14d
system:discovery                                       ClusterRole/system:discovery                                                       14d
system:kube-controller-manager                         ClusterRole/system:kube-controller-manager                                         14d
system:kube-dns                                        ClusterRole/system:kube-dns                                                        14d
system:kube-scheduler                                  ClusterRole/system:kube-scheduler                                                  14d
system:monitoring                                      ClusterRole/system:monitoring                                                      14d
system:node                                            ClusterRole/system:node                                                            14d
system:node-proxier                                    ClusterRole/system:node-proxier                                                    14d
system:public-info-viewer                              ClusterRole/system:public-info-viewer                                              14d
system:service-account-issuer-discovery                ClusterRole/system:service-account-issuer-discovery                                14d
system:volume-scheduler                                ClusterRole/system:volume-scheduler                                                14d

```

```
$ kubectl get clusterroles
NAME                                                                   CREATED AT
admin                                                                  2022-05-20T11:43:20Z
cluster-admin                                                          2022-05-20T11:43:19Z
edit                                                                   2022-05-20T11:43:20Z
kubeadm:get-nodes                                                      2022-05-20T11:43:23Z
kubernetes-dashboard                                                   2022-05-20T15:43:33Z
system:aggregate-to-admin                                              2022-05-20T11:43:20Z
system:aggregate-to-edit                                               2022-05-20T11:43:20Z
system:aggregate-to-view                                               2022-05-20T11:43:20Z
system:auth-delegator                                                  2022-05-20T11:43:20Z
system:basic-user                                                      2022-05-20T11:43:19Z
system:certificates.k8s.io:certificatesigningrequests:nodeclient       2022-05-20T11:43:20Z
system:certificates.k8s.io:certificatesigningrequests:selfnodeclient   2022-05-20T11:43:20Z
system:certificates.k8s.io:kube-apiserver-client-approver              2022-05-20T11:43:20Z
system:certificates.k8s.io:kube-apiserver-client-kubelet-approver      2022-05-20T11:43:20Z
system:certificates.k8s.io:kubelet-serving-approver                    2022-05-20T11:43:20Z
system:certificates.k8s.io:legacy-unknown-approver                     2022-05-20T11:43:20Z
system:controller:attachdetach-controller                              2022-05-20T11:43:20Z
system:controller:certificate-controller                               2022-05-20T11:43:20Z
system:controller:clusterrole-aggregation-controller                   2022-05-20T11:43:20Z
system:controller:cronjob-controller                                   2022-05-20T11:43:20Z
system:controller:daemon-set-controller                                2022-05-20T11:43:20Z
system:controller:deployment-controller                                2022-05-20T11:43:20Z
system:controller:disruption-controller                                2022-05-20T11:43:20Z
system:controller:endpoint-controller                                  2022-05-20T11:43:20Z
system:controller:endpointslice-controller                             2022-05-20T11:43:20Z
system:controller:endpointslicemirroring-controller                    2022-05-20T11:43:20Z
system:controller:ephemeral-volume-controller                          2022-05-20T11:43:20Z
system:controller:expand-controller                                    2022-05-20T11:43:20Z
system:controller:generic-garbage-collector                            2022-05-20T11:43:20Z
system:controller:horizontal-pod-autoscaler                            2022-05-20T11:43:20Z
system:controller:job-controller                                       2022-05-20T11:43:20Z
system:controller:namespace-controller                                 2022-05-20T11:43:20Z
system:controller:node-controller                                      2022-05-20T11:43:20Z
system:controller:persistent-volume-binder                             2022-05-20T11:43:20Z
system:controller:pod-garbage-collector                                2022-05-20T11:43:20Z
system:controller:pv-protection-controller                             2022-05-20T11:43:20Z
system:controller:pvc-protection-controller                            2022-05-20T11:43:20Z
system:controller:replicaset-controller                                2022-05-20T11:43:20Z
system:controller:replication-controller                               2022-05-20T11:43:20Z
system:controller:resourcequota-controller                             2022-05-20T11:43:20Z
system:controller:root-ca-cert-publisher                               2022-05-20T11:43:20Z
system:controller:route-controller                                     2022-05-20T11:43:20Z
system:controller:service-account-controller                           2022-05-20T11:43:20Z
system:controller:service-controller                                   2022-05-20T11:43:20Z
system:controller:statefulset-controller                               2022-05-20T11:43:20Z
system:controller:ttl-after-finished-controller                        2022-05-20T11:43:20Z
system:controller:ttl-controller                                       2022-05-20T11:43:20Z
system:coredns                                                         2022-05-20T11:43:24Z
system:discovery                                                       2022-05-20T11:43:19Z
system:heapster                                                        2022-05-20T11:43:20Z
system:kube-aggregator                                                 2022-05-20T11:43:20Z
system:kube-controller-manager                                         2022-05-20T11:43:20Z
system:kube-dns                                                        2022-05-20T11:43:20Z
system:kube-scheduler                                                  2022-05-20T11:43:20Z
system:kubelet-api-admin                                               2022-05-20T11:43:20Z
system:monitoring                                                      2022-05-20T11:43:19Z
system:node                                                            2022-05-20T11:43:20Z
system:node-bootstrapper                                               2022-05-20T11:43:20Z
system:node-problem-detector                                           2022-05-20T11:43:20Z
system:node-proxier                                                    2022-05-20T11:43:20Z
system:persistent-volume-provisioner                                   2022-05-20T11:43:20Z
system:public-info-viewer                                              2022-05-20T11:43:20Z
system:service-account-issuer-discovery                                2022-05-20T11:43:20Z
system:volume-scheduler                                                2022-05-20T11:43:20Z
view                                                                   2022-05-20T11:43:20Z
sysadmin@sysadmin-virtual-machine:~$
```



# kubectl 基操

kubectl get all

### kubectl options

```bash
$ kubectl options
The following options can be passed to any command:

      --add-dir-header=false: If true, adds the file directory to the header of the log messages (DEPRECATED: will be
removed in a future release, see
https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --alsologtostderr=false: log to standard error as well as files (DEPRECATED: will be removed in a future release,
see
https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --as='': Username to impersonate for the operation. User could be a regular user or a service account in a
namespace.
      --as-group=[]: Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid='': UID to impersonate for the operation.
      --cache-dir='/home/sysadmin/.kube/cache': Default cache directory
      --certificate-authority='': Path to a cert file for the certificate authority
      --client-certificate='': Path to a client certificate file for TLS
      --client-key='': Path to a client key file for TLS
      --cluster='': The name of the kubeconfig cluster to use
      --context='': The name of the kubeconfig context to use
      --insecure-skip-tls-verify=false: If true, the server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kubeconfig='': Path to the kubeconfig file to use for CLI requests.
      --log-backtrace-at=:0: when logging hits line file:N, emit a stack trace (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --log-dir='': If non-empty, write log files in this directory (DEPRECATED: will be removed in a future release,see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --log-file='': If non-empty, use this log file (DEPRECATED: will be removed in a future release, see
https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --log-file-max-size=1800: Defines the maximum size a log file can grow to. Unit is megabytes. If the value is 0, the maximum file size is unlimited. (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --log-flush-frequency=5s: Maximum number of seconds between log flushes
      --logtostderr=true: log to standard error instead of files (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --match-server-version=false: Require server version to match client version
  -n, --namespace='': If present, the namespace scope for this CLI request
      --one-output=false: If true, only write logs to their native severity level (vs also writing to each lower severity level) (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --password='': Password for basic authentication to the API server
      --profile='none': Name of profile to capture. One of (none|cpu|heap|goroutine|threadcreate|block|mutex)
      --profile-output='profile.pprof': Name of the file to write the profile to
      --request-timeout='0': The length of time to wait before giving up on a single server request. Non-zero values
should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests.
  -s, --server='': The address and port of the Kubernetes API server
      --skip-headers=false: If true, avoid header prefixes in the log messages (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --skip-log-headers=false: If true, avoid headers when opening log files (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --stderrthreshold=2: logs at or above this threshold go to stderr (DEPRECATED: will be removed in a future release, see https://github.com/kubernetes/enhancements/tree/master/keps/sig-instrumentation/2845-deprecate-klog-specific-flags-in-k8s-components)
      --tls-server-name='': Server name to use for server certificate validation. If it is not provided, the hostname used to contact the server is used
      --token='': Bearer token for authentication to the API server
      --user='': The name of the kubeconfig user to use
      --username='': Username for basic authentication to the API server
      -v, --v=0: number for the log level verbosity
      --vmodule=: comma-separated list of pattern=N settings for file-filtered logging
      --warnings-as-errors=false: Treat warnings received from the server as errors and exit with a non-zero exit code
```

### kubectl get

```bash
$ kubectl  get -h
Display one or many resources.

 Prints a table of the most important information about the specified resources. You can filter the list using a label
selector and the --selector flag. If the desired resource type is namespaced you will only see results in your current
namespace unless you pass --all-namespaces.

 By specifying the output as 'template' and providing a Go template as the value of the --template flag, you can filter
the attributes of the fetched resources.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # List all pods in ps output format
  kubectl get pods

  # List all pods in ps output format with more information (such as node name)
  kubectl get pods -o wide

  # List a single replication controller with specified NAME in ps output format
  kubectl get replicationcontroller web

  # List deployments in JSON output format, in the "v1" version of the "apps" API group
  kubectl get deployments.v1.apps -o json

  # List a single pod in JSON output format
  kubectl get -o json pod web-pod-13je7

  # List a pod identified by type and name specified in "pod.yaml" in JSON output format
  kubectl get -f pod.yaml -o json

  # List resources from a directory with kustomization.yaml - e.g. dir/kustomization.yaml
  kubectl get -k dir/

  # Return only the phase value of the specified pod
  kubectl get -o template pod/web-pod-13je7 --template={{.status.phase}}

  # List resource information in custom columns
  kubectl get pod test-pod -o custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image

  # List all replication controllers and services together in ps output format
  kubectl get rc,services

  # List one or more resources by their type and names
  kubectl get rc/web service/frontend pods/web-pod-13je7

Options:
  -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
context is ignored even if specified with --namespace.
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in
the template. Only applies to golang and jsonpath output formats.
      --chunk-size=500: Return large lists in chunks rather than all at once. Pass 0 to disable. This flag is beta and
may change in the future.
      --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
key1=value1,key2=value2). The server only supports a limited number of field queries per type.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to get from a server.
      --ignore-not-found=false: If the requested object does not exist the command will return exit code 0.
  -k, --kustomize='': Process the kustomization directory. This flag can't be used together with -f or -R.
  -L, --label-columns=[]: Accepts a comma separated list of labels that are going to be presented as columns. Names are
case-sensitive. You can also use multiple flag options like -L label1 -L label2...
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print
headers).
  -o, --output='': Output format. One of:
json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-as-json|jsonpath-file|custom-columns-file|custom-columns|wide
See custom columns [https://kubernetes.io/docs/reference/kubectl/overview/#custom-columns], golang template
[http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
[https://kubernetes.io/docs/reference/kubectl/jsonpath/].
      --output-watch-events=false: Output watch event objects when --watch or --watch-only is used. Existing objects are
output as initial ADDED events.
      --raw='': Raw URI to request from the server.  Uses the transport specified by the kubeconfig file.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
related manifests organized within the same directory.
  -l, --selector='': Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)
      --server-print=true: If true, have the server return the appropriate table output. Supports extension APIs and
CRDs.
      --show-kind=false: If present, list the resource type for the requested object(s).
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --show-managed-fields=false: If true, keep the managedFields when printing objects in JSON or YAML format.
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed
as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression
must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
  -w, --watch=false: After listing/getting the requested object, watch for changes.
      --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.

Usage:
  kubectl get
[(-o|--output=)json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-as-json|jsonpath-file|custom-columns-file|custom-columns|wide]
(TYPE[.VERSION][.GROUP] [NAME | -l label] | TYPE[.VERSION][.GROUP]/NAME ...) [flags] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).
```

### kubectl run

```bash
$ kubectl run kubia --image=luksa/kubia --port=8080
```

### kubectl pod

```bash
### 操作 pod 
$ cat << EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  # 定义容器，可以多个
  containers:
    - name: test-k8s # 容器名字
      image: ccr.ccs.tencentyun.com/k8s-tutorial/test-k8s:v1 # 镜像
EOF

$ kubectl apply -f pod.yaml          # pod 启动
$ kubectl describe pod/test-pod      # pod 详情
$ kubectl exec -it test-pod -- bash  # pod 运维
```

### kubectl deployment

操作 deployment

```bash
$ cat << EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  # 部署名字
  name: test-k8s
spec:
  replicas: 2
  # 用来查找关联的 Pod，所有标签都匹配才行
  selector:
    matchLabels:
      app: test-k8s
  # 定义 Pod 相关数据
  template:
    metadata:
      labels:
        app: test-k8s
    spec:
      # 定义容器，可以多个
      containers:
      - name: test-k8s # 容器名字
        image: ccr.ccs.tencentyun.com/k8s-tutorial/test-k8s:v1 # 镜像
EOF
```

```
$ kubectl apply -f deployment.yaml
```

```
$ kubectl describe deployment.apps/test-k8s
```

### kubectl replicationcontrollers

现在有了一个正在运行的应用， 由 ReplicationController 监控并保持运行，
pod 由 一个 ReplicationController 管理。 让我们来查看 kubectl get 命令

```
$ kubectl get replicationcontrollers
```

增加期望的副本数,为了增加pod的副本数，需要改变 ReplicationController期望的副本数，如下所示
```
$ kubectl scale re kubia --replicas=3
```

查看扩容的结果，前面增加了 pod的副本数。再次列出 ReplicationController 查看更新后的副本数：
```
$ kubectl get rc
$ kubectl get pods 
```

### kubectl service

创建一个服务
```
$ kubectl expose re kubia --type=LoadBalancer --name kubia-http 

```

```bash
$ cat << EOF >  service.yaml
apiVersion: v1
kind: Service
metadata:
  name: test-k8s
spec:
  selector:
    app: test-k8s
  type: NodePort
  ports:
    - port: 8080        # 本 Service 的端口
      targetPort: 8080  # 容器端口
      nodePort: 31000
EOF
```

```
$ kubectl apply -f service.yaml
```

```
$ kubectl describe service/test-k8s
```

### kubectl secret

操作 secret

```bash
$ cat << EOF >  secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
# Opaque 用户定义的任意数据，更多类型介绍 https://kubernetes.io/zh/docs/concepts/configuration/secret/#secret-types
type: Opaque
data:
  # 数据要 base64。https://tools.fun/base64.html
  mongo-username: bW9uZ291c2Vy
  mongo-password: bW9uZ29wYXNz
EOF
```

部署操作

```
$ kubectl apply -f secret.yaml
```

查看详情

```
$ kubectl get secret mongo-secret  -o json
```

demo

```bash
$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      14d
sysadmin@sysadmin-virtual-machine:~$ kubectl get secret
NAME                  TYPE                                  DATA   AGE
default-token-99q6w   kubernetes.io/service-account-token   3      14d
foo-token-qk8bw       kubernetes.io/service-account-token   3      44h
mongo-secret          Opaque                                2      2d10h
```

### kubectl namespace

创建命名空间和运行pod

```bash
$ kubectl get ns

$ kubectl create ns foe
> name space "foo" create

$ kubectl run test --image=luksa/kubect1-proxy -n foe 
> deployment "test" created

$ kubect1 create ns bar 
> namespace "bar" created

$ kubectl run test --image=luksa/kubectl-proxy -n bar 
> deployment "test" created
```

### kuebctl tab 补全

```
$ apt install bash-completion

# 注意<后面没有空格
$ source <(kubectl completion bash)

alias k =kubectl
```

# 攻击面安全评估项

### 风险1：容器可以访问到K8S控制中心APIserver

低版本可能存在默认未授权访问
```
$ curl  -k  https://kubernetes/
{  "kind": "Status","apiVersion": "v1", "metadata": {}, "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden", "details": {}, "code": 403 }
```
### 风险2：默认的服务账号，权限较大。

默认服务账号 /var/run/secrets/kubernetes.io/serviceaccount/token文件内容来进行身份认证的 
```
cd /var/run/secrets/kubernetes.io/serviceaccount/
TOKEN=`cat token`
curl -H "Authorization: Bearer $TOKEN"  --cacert ca.crt  https://kubernetes/api/v1/namespaces/default/pods
```

### 风险3：高权限的账号证书泄露，可以直接控制APIserver

```
curl --cacert /home/sysadmin/.minikube/ca.crt --key /home/sysadmin/.minikube/profiles/minikube/client.key --cert /home/sysadmin/.minikube/profiles/minikube/client.crt  https://192.168.49.2:8443/api/v1/namespaces/default/pods
```

poc 搜索证书，是否可以访问K8s
```
find / -name *.crt
openssl x509 -noout -text -in ca.crt 
```

### 风险4：授予普通账号高权限

用cluster-adminClusterRole得到完全的控制

```
kubectl create clusterrolebinding admin-test --clusterrole=cluster-admin
--serviceaccount=foo:default 
--user=xx
--group=yy
```

### 容器中窃取密码

默认位置：/run/secrets/mysql_root_password
```
https://www.cnblogs.com/CloudMan6/p/8068057.html
我们经常要向容器传递敏感信息，最常见的莫过于密码了。比如：

docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql

在启动 MySQL 容器时我们通过环境变量 MYSQL_ROOT_PASSWORD 设置了 MySQL 的管理员密码。不过密码是以明文的形式写在 docker run 命令中，有潜在的安全隐患。

为了解决这个问题，docker swarm 提供了 secret 机制，允许将敏感信息加密后保存到 secret 中，用户可以指定哪些容器可以使用此 secret。

如果使用 secret 启动 MySQL 容器，方法是：在 swarm manager 中创建 secret my_secret_data，将密码保存其中。

echo "my-secret-pw" | docker secret create my_secret_data -

启动 MySQL service，并指定使用 secret my_secret_data。

docker service create \
        --name mysql \
        --secret source=my_secret_data,target=mysql_root_password \
        -e MYSQL_ROOT_PASSWORD_FILE="/run/secrets/mysql_root_password" \
        mysql:latest
```

### 窃取Secret的方法

```
### 在容器中获取
1.在环境变量和文件中寻找secret。在第7章中，你学会如何创建密钥并且把它们挂载进一个pod 里，将 Secret 条目作为环境变量传递给容器 • 将 Secret 条目暴露为卷中的文件

### 在API中获取
2.通过读取api获得secret，Secret 通常以非加密形式存储在etcd，通过https直接读取secret。从 Kubemetes 1. 7 开始， etcd 会以加密形式存储 Secret, 某种程度提高了系统的安全性。
$ kubectl get secret
$ curl https://kubernetes/api/v1/namespaces/default/secret

3.ConfigMap也可能存在敏感信息
$ kubectl get configmap

### 其他手法
4.通过创建 pod 并将 Secret挂载来获得此类敏感数据

```

