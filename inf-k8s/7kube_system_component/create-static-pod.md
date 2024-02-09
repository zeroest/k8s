
# 스태틱 파드 생성

## 스태틱 파드 설정

**저장시 즉시 반영되기 때문에 주의가 필요하다!**

`kubectl run static-web --image nginx --dry-run=client -o yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: static-web
  labels:
    role: myrole
spec:
  containers:
  - name: web
    image: nginx
    ports:
    - name: web
      containerPort: 80
      protocol: TCP
```

```bash
cd /etc/kubernetes/manifests
vim static-pod.yaml
# 위 yaml 파일 반영
```

```bash
kubectl get pod -w
NAME                READY   STATUS    RESTARTS   AGE
static-web-k8s-01   1/1     Running   0          14s
```

Static Pod 로 등록되면 파드가 삭제되어도 즉시 복구한다
```bash
kubectl delete pod static-web-k8s-01
pod "static-web-k8s-01" deleted

kubectl get pod -w
NAME                READY   STATUS    RESTARTS   AGE
static-web-k8s-01   0/1     Pending   0          3s
static-web-k8s-01   1/1     Running   0          5s
```

## ~~Static Pod 위치 설정~~

~~다음 명령어 들을 사용하여 실행하고자 하는 static pod의 위치를 설정 가능~~

```bash
sudo systemctl status kubelet

● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Fri 2024-02-09 05:46:31 UTC; 4h 4min ago
       Docs: https://kubernetes.io/docs/home/
   Main PID: 459 (kubelet)
      Tasks: 13 (limit: 2292)
     Memory: 104.9M
     CGroup: /system.slice/kubelet.service
             └─459 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml>
```

~~`--pod-manifest-path=/etc/kubelet.d/` 옵션 추가~~
```bash
vim /lib/systemd/system/kubelet.service

[Service]
ExecStart=/usr/bin/kubelet --pod-manifest-path=/etc/kubelet.d/
```

```bash
systemctl daemon-reload
systemctl restart kubelet
```
