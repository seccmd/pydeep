# K3S Guide

Got it 👍 You want a **practice note / guide** to learn **k3s** with a demo.
Here’s a step-by-step note you can follow to get hands-on quickly:

---

# 📝 k3s Practice Note (Demo Setup)

## 1. What is k3s?

* **k3s** = lightweight Kubernetes (by Rancher/ SUSE).
* Perfect for **local testing, small clusters, IoT, edge, CI/CD**.
* Single binary, very easy to install.

---

## 2. Prerequisites

* A Linux server (VM, VPS, or local with Docker/Multipass).

  * Ubuntu 20.04+ or CentOS 8 recommended.
* At least **2 vCPU, 2GB RAM, 10GB disk**.
* Root or sudo access.

---

## 3. Install k3s (Server Node)

On your node (VM / VPS):

```bash
curl -sfL https://get.k3s.io | sh -
```

Check status:

```bash
systemctl status k3s
```

Check cluster nodes:

```bash
kubectl get nodes
```

👉 By default, `kubectl` is already installed and configured (`/etc/rancher/k3s/k3s.yaml`).

---

## 4. Deploy a Demo App

Let’s deploy **nginx** to test the cluster.

```bash
kubectl create deployment demo-nginx --image=nginx --replicas=2
kubectl expose deployment demo-nginx --type=NodePort --port=80
```

Check resources:

```bash
kubectl get pods
kubectl get svc
```

Find NodePort service (e.g., `30000-32767`).
Access in browser:

```
http://<server-ip>:<nodeport>
```

---

## 5. (Optional) Add Worker Nodes

On another Linux machine, run (replace `<token>` and `<server-ip>`):

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<server-ip>:6443 K3S_TOKEN=<token> sh -
```

Find token on master:

```bash
cat /var/lib/rancher/k3s/server/node-token
```

Check cluster:

```bash
kubectl get nodes
```

---

## 6. Try Scaling the App

```bash
kubectl scale deployment demo-nginx --replicas=5
kubectl get pods -o wide
```

---

## 7. Cleanup

Remove k3s:

```bash
/usr/local/bin/k3s-uninstall.sh
```

---

## ✅ Practice Checklist

* [ ] Install k3s server
* [ ] Verify cluster (`kubectl get nodes`)
* [ ] Deploy nginx demo app
* [ ] Expose service (NodePort)
* [ ] Scale deployment
* [ ] (Optional) Add worker node

---

Perfect 👌 You already learned how to deploy a simple app with **NodePort** — now let’s step it up with an **Ingress** (which is the “Kubernetes way” to expose apps).

Here’s a **practice note for a simple Ingress demo in k3s**:

---

# 📝 Practising Ingress in k3s

## 1. Background

* **Ingress** lets you expose HTTP/HTTPS routes to services inside your cluster.
* In normal Kubernetes, you need to install an Ingress Controller (like Nginx).
* In **k3s**, the **Traefik Ingress Controller** is **already built-in** 🎉 (enabled by default).

---

## 2. Create a Test Deployment & Service

Let’s make two apps so you can see how Ingress routes traffic.

### App 1: `app1`

```bash
kubectl create deployment app1 --image=nginx
kubectl expose deployment app1 --port=80
```

### App 2: `app2`

```bash
kubectl create deployment app2 --image=httpd
kubectl expose deployment app2 --port=80
```

Check:

```bash
kubectl get svc
```

---

## 3. Create an Ingress Resource

Make a YAML file `demo-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-ingress
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
  - host: app1.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1
            port:
              number: 80
  - host: app2.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app2
            port:
              number: 80
```

Apply it:

```bash
kubectl apply -f demo-ingress.yaml
```

---

## 4. Test the Ingress

Find your server IP:

```bash
kubectl get nodes -o wide
```

Edit your local machine’s **hosts file** (`/etc/hosts` on Linux/Mac, `C:\Windows\System32\drivers\etc\hosts` on Windows) and add:

```
<server-ip>  app1.local
<server-ip>  app2.local
```

Now test in browser or curl:

```bash
curl http://app1.local
curl http://app2.local
```

You should see **nginx page** for app1 and **Apache httpd page** for app2.

---

## 5. Cleanup

```bash
kubectl delete ingress demo-ingress
kubectl delete svc app1 app2
kubectl delete deployment app1 app2
```

---

## ✅ Ingress Practice Checklist

* [ ] Deploy two apps (nginx + httpd)
* [ ] Create services for them
* [ ] Write an Ingress with host-based routing
* [ ] Edit `/etc/hosts` to resolve test domains
* [ ] Verify with curl or browser

---

Sure! Here's a **clear, practical UFW example** for a small k3s cluster with **1 server, 1 worker, and ingress**:

---

## 🛡️ UFW Rules for k3s Cluster

### 1. **Server Node (control-plane + ingress)**

```bash
# k3s control-plane
ufw allow 6443/tcp       # Kubernetes API server
ufw allow 8472/udp       # Flannel VXLAN networking (pod network)
ufw allow 10250/tcp      # Kubelet API

# NodePort / LoadBalancer / Ingress traffic
ufw allow 30000:32767/tcp  # NodePort range
ufw allow 80/tcp           # HTTP (Ingress)
ufw allow 443/tcp          # HTTPS (Ingress)
```

---

### 2. **Worker Node**

```bash
# Needed to join the cluster and run pods
ufw allow 10250/tcp      # Kubelet API
ufw allow 8472/udp       # Flannel VXLAN networking (pod network)

# NodePort / Ingress traffic
ufw allow 30000:32767/tcp  # NodePort range
ufw allow 80/tcp           # HTTP (Ingress)
ufw allow 443/tcp          # HTTPS (Ingress)
```

---

### 3. **Optional: etcd / HA setup**

If you later set up **multi-server high-availability**, also open on server nodes:

```bash
ufw allow 2379:2380/tcp  # etcd client/peer communication
```

---

### 4. **Enable UFW (if not already)**

```bash
ufw enable
ufw status
```

---

✅ **Summary**

* **Server**: open control-plane ports + NodePort + ingress
* **Worker**: open kubelet & networking + NodePort + ingress
* **Ingress**: traffic comes through NodePort or 80/443

---

