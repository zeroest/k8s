
# TLS Certificate

## 정확한 TLS 인증서 사용 점검 
- 적절한 키를 사용하는지 /etc/kubernetes/manifests 폴더의 각 서비스 yaml 파일에 certificate 확인

## 인증서 위치

```bash
ls /etc/kubernetes/pki

apiserver.crt              apiserver.key                 ca.crt  front-proxy-ca.crt      front-proxy-client.key
apiserver-etcd-client.crt  apiserver-kubelet-client.crt  ca.key  front-proxy-ca.key      sa.key
apiserver-etcd-client.key  apiserver-kubelet-client.key  etcd    front-proxy-client.crt  sa.pub

ls /etc/kubernetes/pki/etcd

ca.crt  ca.key  healthcheck-client.crt  healthcheck-client.key  peer.crt  peer.key  server.crt  server.key
```

## Kubelet 인증서 위치
- /var/lib/kubelet/config.yaml 참조

```bash
ls /var/lib/kubelet/pki

kubelet-client-2021-11-24-17-51-30.pem  kubelet-client-current.pem  kubelet.crt  kubelet.key
```

## 인증서 정보 확인

```bash
sudo openssl x509 -in ${certificate} -text
```

---

- Certificate

| CERTIFICATE              | RESIDUAL TIME | CERTIFICATE PATH         | CERTIFICATE AUTHORITY |
| ------------------------ | ------------- | ------------------------ | --------------------- |
| admin.conf               | 365d          | /etc/kubernetes          |                       |
| apiserver                | 365d          | /etc/kubernetes/pki      | ca                    |
| apiserver-etcd-client    | 365d          | /etc/kubernetes/pki/etcd | etcd-ca               |
| apiserver-kubelet-client | 365d          | /etc/kubernetes/pki      | ca                    |
| controller-manager.conf  | 365d          | /etc/kubernetes/pki      |                       |
| etcd-healthcheck-client  | 365d          | /etc/kubernetes/pki/etcd | etcd-ca               |
| etcd-peer                | 365d          | /etc/kubernetes/pki/etcd | etcd-ca               |
| etcd-server              | 365d          | /etc/kubernetes/pki/etcd | etcd-ca               |
| front-proxy-client       | 365d          | /etc/kubernetes/pki      | front-proxy-ca        |
| scheduler.conf           | 365d          | /etc/kubernetes          |                       |


- CA

| CERTIFICATE AUTHORITY | RESIDUAL TIME | CERTIFICATE PATH         |
| --------------------- | ------------- | ------------------------ |
| ca                    | 10y           | /etc/kubernetes/pki      |
| etcd-ca               | 10y           | /etc/kubernetes/pki/etcd |
| front-proxy-ca        | 10y           | /etc/kubernetes/pki      |

---

## 인증서 갱신

[kubeadm-certs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)

- 만료 확인

```bash
kubeadm certs check-expiration
```

- 갱신

```bash
kubeadm certs renew all
```

kubeadm은 컨트롤 플레인을 업그레이드 하면 모든 인증서 자동 갱신


## 인증서 유저 사용

1. Private key
```bash
openssl genrsa -out zero.key 2048
```

2. CSR
```bash
openssl req -new -key zero.key -out zero.csr -subj "/CN=zero/O=zeroest"

# CN - common name
# O - Organization
```

3. Sign
- Kubernetes 클러스터 CA 를 통해 CSR 승인
- /etc/kubernetes/pki의 ca.key와 ca.crt를 사용하여 승인
- -days 옵션을 사용해 인증서 유효기간 설정

```bash
openssl x509 -req -in zero.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out zero.crt -days 500

Signature ok
subject=CN = zero, O = zeroest
Getting CA Private Key
```

4. Set user
```bash
kubectl config set-credentials zero --client-certificate=zero.crt --client-key=zero.key
kubectl config set-context zero@kubernetes --cluster=kubernetes --namespace=dev --user=zero
kubectl config use-context zero@kubernetes

kubectl get pod --context=zero@kubernetes
```
**위 설정한 user 와 context 는 ~/.kube/config 파일에 정리된다.**


## kube config

```bash
curl https://kube-api-server:6443/api/v1/pods \
        --key zero.key \
        --cert zero.crt \
        --cacert /etc/kubernetes/pki/ca.crt
```

```bash
kubectl config view
# kubectl config view --kube config=${config file}
```
- 위 설정 내용은 ~/.kube/config 파일에 정리된다.

- clusters - 연결할 쿠버네티스 클러스터 정보
- users - 사용할 권한을 가진 사용자
- contexts - cluster와 user를 함께 입력하여 권한 할당



