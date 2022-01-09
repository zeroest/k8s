
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


