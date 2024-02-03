
# Setup On Prem
 
- [x]  호환되는 리눅스 머신. 쿠버네티스 프로젝트는 데비안 기반 배포판, 레드햇 기반 배포판, 그리고 패키지 매니저를 사용하지 않는 경우에 대한 일반적인 가이드를 제공한다.
- [x]  2 GB 이상의 램을 장착한 머신. (이 보다 작으면 사용자의 앱을 위한 공간이 거의 남지 않음)
- [x]  2 이상의 CPU.
- [x]  클러스터의 모든 머신에 걸친 전체 네트워크 연결. (공용 또는 사설 네트워크면 괜찮음)
- [x]  모든 노드에 대해 고유한 호스트 이름, MAC 주소 및 product_uuid. 자세한 내용은 [여기](https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#verify-mac-address)를 참고한다.
- [x]  컴퓨터의 특정 포트들 개방. 자세한 내용은 [여기](https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports)를 참고한다.
- [x]  스왑의 비활성화. kubelet이 제대로 작동하게 하려면 **반드시** 스왑을 사용하지 않도록 설정한다.


---

## 노드 설정

### Swap off

[[askubuntu] How do I disable swap?](https://askubuntu.com/questions/214805/how-do-i-disable-swap)

[swap off command](command/swap-off.sh)
```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### 컨테이너 런타임 설치

kubelet 데몬이 containerd 를 컨트롤함 
도커로 설치된 containerd 1.26 버전부터 호환성의 문제로 직접 설치함

[How to Install Containerd on Ubuntu 22.04 / Ubuntu 20.04](https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/install-containerd-on-ubuntu-22-04.html)  
[containerd install command](./command/containerd-install.sh)
```bash
# Using Docker Repository
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# containerd 설치
sudo apt update
sudo apt install -y containerd.io
# sudo systemctl status containerd # Ctrl + C를 눌러서 나간다.

# Containerd configuration for Kubernetes
# 쿠버네티스를 사용하기 위해서 containerd를 런타임으로 등록
cat <<EOF | sudo tee -a /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
# 쿠버네티스가 사용하는 컨트롤 그룹
# 도커의 네임스페이스 중 하나인 컨트롤그룹을 쿠버네티스와 공유시키기 위한 설정
SystemdCgroup = true 
EOF

sudo sed -i 's/^disabled_plugins \=/\#disabled_plugins \=/g' /etc/containerd/config.toml
sudo systemctl restart containerd

# 소켓이 있는지 확인한다.
ls /var/run/containerd/containerd.sock
```

### 쿠버네티스 설치

[packages.cloud.google.com NO_PUBKEY 문제 해결](https://velog.io/@yekim/Ubuntu-20.4-apt-get-update-%EC%97%90%EB%9F%AC)
[Ubuntu kubernetes-xenial public key is not available](https://github.com/kubernetes/release/issues/2862)  
- 레거시 저장소( apt.kubernetes.io및 yum.kubernetes.io)는 더 이상 사용되지 않습니다.
- 구글 클라우드 공개 사이닝 키 다운로드 커맨드 수정 필요
- ```bash
  sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg  https://dl.k8s.io/apt/doc/apt-key.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  ```

[Install kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)  
[kube install command](./command/kube_install.sh)

- kubeadm: 
  - 클러스터를 부트스트랩하는 명령 
  - 클러스터를 초기화하고 관리하는 기능을 갖는다
- kubelet: 
  - 클러스터의 모든 머신에서 실행되는 파드와 컨테이너 시작과 같은 작업을 수행하는 컴포넌트
  - 데몬으로 동작하며 컨테이너를 관리한다
- kubectl: 
  - 클러스터와 통신하기 위한 커맨드 라인 유틸리티
  - 클라이언트 전용 프로그램

### 넷필터 브릿지 설정

쿠버네티스, 도커의 경우 넷필터의 브릿지 설정을 통해 컨테이너의 네트워크 통신을 시켜주는 역할  
docker.io 를 설치하면 기본 설치되나 containerd를 직접 설치하기 때문에 넷필터 설정도 직접 해준다  

```bash
sudo -i
modprobe br_netfilter
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
exit

or

sudo modprobe br_netfilter
sudo bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo bash -c 'echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables'
```

설정을 통해 Linux 시스템에서 NAT(네트워크 주소 변환)를 설정하는 데 사용

- NAT는 단일 공용 IP 주소를 사용하여 여러 장치를 인터넷에 연결하는 방법
- `modprobe br_netfilter` 명령은 네트워크 스택과 Linux 브리지 간에 패킷을 전달 할 수 있도록 하는 데 사용되는 커널 모듈을 로드
- `echo 1 > /proc/sys/net/ipv4/ip_forward` 명령은 Linux 커널에서 패킷 전달을 활성화하며 NAT에는 한 네트워크에서 다른 네트워크로 패킷을 전달하는 작업이 포함되기 때문에 이 작업이 필요
- `echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables` 명령은 Linux 브리지가 인터페이스 간에 패킷이 전달될때 iptables 규칙을 호출할 수 있도록 하며 이렇게 하면 NAT 규칙이 브리지를 통과할 때 패킷에 적용 가능

---

## 클러스터 설정

### 마스터 노트 초기화

마스터 노드에서 init 작업을 시작

`sudo kubeadm init`

init 시점에 HA 구성에 대한 즉 컨트롤 플랜을 여러개 구성할것이라는 옵션을 설정해주면  
마스터 노드 조인에 대한 명렬어 또한 설치완료 후 제공해준다

- [ha topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/)
- [kubeadm high-availability](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)

초기화 성공시 아래와 같은 가이드가 나오고 가이드에 맞춰 설정한다
```log
Your Kubernetes control-plane has initialized successfully!

# 1) 유저 설정
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

# 2) 파드 네트워크 설정
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

# 3) 워커 노드 조인 방법
Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.142.0.3:6443 --token xcs79e.vnernooln6yyimtv \
        --discovery-token-ca-cert-hash sha256:c9f8642746515eadc28e72c687eface2fa64da93ddca5a30b4ccf931dbcce839
```

### 1) 유저 설정

To start using your cluster, you need to run the following as a regular user:  
유저 설정 후 `kubectl` 에 대한 명령 실행 가능
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 2) 파드 네트워크 설정

쿠버네티스가 정상적으로 구동되기 위해서는 컨테이너끼리에 네트워크를 구성해주는 Addon이 필요하다  
Addon으로 cilium 설치 마스터 노드에서 실행한다

- [k8s install network policy docs](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/)
- [k8s cilium docs](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/cilium-network-policy/)  
- [install cilium](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/)
```
curl -LO https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
rm cilium-linux-amd64.tar.gz
cilium install
cilium status # 상태 확인
```

### 3) 워커 노드 조인

관리자 권한이 필요하기에 sudo를 붙여 실행하자

```bash
kubeadm join 10.142.0.3:6443 --token xcs79e.vnernooln6yyimtv \
        --discovery-token-ca-cert-hash sha256:c9f8642746515eadc28e72c687eface2fa64da93ddca5a30b4ccf931dbcce839
```

### 노드 상태 확인

파드 네트워크 설정이 없을 경우 `NotReady`, 파드 네트워크를 확인하자

```bash
$ kubectl get nodes
NAME       STATUS   ROLES           AGE   VERSION
master-1   Ready    control-plane   31m   v1.26.0
worker-1   Ready    <none>          24m   v1.26.0
worker-2   Ready    <none>          24m   v1.26.0
```

## Trouble

- init이나 join을 잘못 수행한 경우
  - `sudo kubeadm reset`을 사용해 초기 설정으로 돌아갈 수 있다.
  - 위 명령어로 init 전 상태로 돌아간다

- token 재발급 받는 방법 (마스터 노드에서 실습)
  - 토큰 리스트 확인하기: sudo kubeadm token list
  - 토큰 재발급하기: sudo kubeadm token create --print-join-command

## Addon?

- https://ikcoo.tistory.com/3
- https://kubernetes.io/ko/docs/concepts/cluster-administration/addons/

# ETC

## Install Docker

[[Docs] Docker engine install](https://docs.docker.com/engine/install/)

- [docker install on ubuntu command](command/docker-install-ubuntu.sh)
- [add user on docker group](command/usermode-add-group-docker.sh)

## 호스트 네임 변경

[linux static hostname on ubuntu](https://repost.aws/ko/knowledge-center/linux-static-hostname)

```bash
sudo hostnamectl set-hostname ${your-new-hostname}

or

sudo vim /etc/hosts
  127.0.0.1 localhost ${your-new-hostname}
sudo vim /etc/hostname
  ${your-new-hostname}
```

## 클러스터 노드 호스트 네임 주소 설정

```bash
sudo vim /etc/hosts
```

