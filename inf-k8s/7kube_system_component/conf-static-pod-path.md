
# Static Pod 경로 확인

kube-system 네임스페이스에 파드들이 `/etc/kubernetes/manifests/` 하위 yaml 파일로 정의되어 있다

```bash
ll /etc/kubernetes/manifests/

total 24
drwxr-xr-x 2 root root 4096 Feb  3 08:24 ./
drwxr-xr-x 4 root root 4096 Feb  3 08:24 ../
-rw------- 1 root root 2393 Feb  3 08:24 etcd.yaml
-rw------- 1 root root 4032 Feb  3 08:24 kube-apiserver.yaml
-rw------- 1 root root 3429 Feb  3 08:24 kube-controller-manager.yaml
-rw------- 1 root root 1463 Feb  3 08:24 kube-scheduler.yaml
```

```bash
kubectl get pod -n kube-system

NAME                             READY   STATUS    RESTARTS        AGE    IP              NODE     NOMINATED NODE   READINESS GATES
cilium-k457h                     1/1     Running   1 (3h40m ago)   6d     192.168.0.108   k8s-03   <none>           <none>
cilium-operator-684cb65b-b5fwq   1/1     Running   1 (3h40m ago)   6d     192.168.0.108   k8s-03   <none>           <none>
cilium-sf762                     1/1     Running   1 (3h40m ago)   6d     192.168.0.193   k8s-02   <none>           <none>
cilium-xw9j2                     1/1     Running   1 (3h40m ago)   6d     192.168.0.67    k8s-01   <none>           <none>
coredns-5dd5756b68-nvcjv         1/1     Running   1 (3h40m ago)   6d1h   10.0.0.58       k8s-02   <none>           <none>
coredns-5dd5756b68-vn5t4         1/1     Running   1 (3h40m ago)   6d1h   10.0.0.247      k8s-02   <none>           <none>
etcd-k8s-01                      1/1     Running   1 (3h40m ago)   6d1h   192.168.0.67    k8s-01   <none>           <none>
kube-apiserver-k8s-01            1/1     Running   1 (3h40m ago)   6d1h   192.168.0.67    k8s-01   <none>           <none>
kube-controller-manager-k8s-01   1/1     Running   1 (3h40m ago)   6d1h   192.168.0.67    k8s-01   <none>           <none>
kube-proxy-6p2sf                 1/1     Running   1 (3h40m ago)   6d1h   192.168.0.67    k8s-01   <none>           <none>
kube-proxy-fs799                 1/1     Running   1 (3h40m ago)   6d     192.168.0.193   k8s-02   <none>           <none>
kube-proxy-wgsgl                 1/1     Running   1 (3h40m ago)   6d     192.168.0.108   k8s-03   <none>           <none>
kube-scheduler-k8s-01            1/1     Running   1 (3h40m ago)   6d1h   192.168.0.67    k8s-01   <none>           <none>
```
cf. kube-proxy, cilium은 각 노드마다 존재 

## 스태틱 파드 경로 확인

kubelet 데몬 status 확인시 kubelet 서비스를 실행해주는 파일 확인 가능 (`Drop-In` 옆 kubelet.service.d)
```bash
service kubelet status

● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Fri 2024-02-09 05:46:31 UTC; 10h ago
       Docs: https://kubernetes.io/docs/home/
   Main PID: 459 (kubelet)
      Tasks: 13 (limit: 2292)
     Memory: 87.4M
     CGroup: /system.slice/kubelet.service
             └─459 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml>
```

`ExecStart`의 실행 명령을 확인할 수 있다  
파라미터로 환경변수를 전달하는것을 확인할 수 있는데  
이 중 `KUBELET_CONFIG_ARGS`의 `--config=/var/lib/kubelet/config.yaml`를 확인하면 된다
```bash
# vim /etc/systemd/system/kubelet.service.d
vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
```

`/var/lib/kubelet/config.yaml` 설정 파일에 `staticPodPath` 경로를 기반으로 static pod 경로가 설정된다
```bash
vim /var/lib/kubelet/config.yaml

staticPodPath: /etc/kubernetes/manifests
```
