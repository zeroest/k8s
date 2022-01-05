
# Static Pod

[doc](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)

- 스태틱 포드: kubelet이 직접 실행하는 포드
- 각각의 노드에서 kubelet에 의해 실행 
- 포드들을 삭제할때 apiserver를 통해서 실행되지 않은 스태틱 포드는 삭제 불가
- 즉, 노드의 필요에 의해 사용하고자 하는 포드는 스태틱 포드로 세팅

```bash
sudo systemctl status kubelet
# Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)

vim /lib/systemd/system/kubelet.service
# ExecStart= 부분에 --pod-manifest-path=/etc/kubelet.d/ 추가

systemctl daemon-reload
systemctl restart kubelet
```
실행하고자 하는 스태틱 포드의 위치를 설정 가능

---

- 기본경로 /etc/kubernetes/manifests
- 이미 쿠버네티스 시스템에서는 필요한 기능을 위해 다음과 같은 스태틱 포드를 사용
- 각각의 컴포넌트의 세부 사항을 설정할 때는 여기 있는 파일들을 수정하면 자동으로 업데이트하여 포드를 재구성

```bash
ls /etc/kubernets/manifests/
etcd.yaml kube-apiserver.yaml kube-controller-manager.yaml kube-scheduler.yaml
```

