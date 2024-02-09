
# Static Pod

[[k8s docs] Static Pods](https://kubernetes.io/docs/concepts/workloads/pods/#static-pods)

- kubelet이 직접 실행하는 파드
- 각각의 노드에서 kubelet에 의해 실행
- 파드들을 삭제할 때 apiserver를 통해서 실행되지 않은 static pod는 삭제 불가
- 즉, 노드의 필요에 의해 사용하고자 하는 파드는 스태틱 파드로 세팅

## Static pod 기본 경로

[Static Pod 경로 확인](./conf-static-pod-path.md)

`/etc/kubernetes/manifests`
```bash
ls /etc/kubernetes/manifests/
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml
```

- 이미 쿠버네티스 시스템에서는 필요한 기능을 위해 다음과 같은 스태틱 파드를 사용
- 각각의 컴포넌트의 세부 사항을 설정할 때는 여기 있는 파일들을 수정하면 자동으로 업데이트돼 파드를 재구성
- 파드의 작성 요령은 기존의 파드와 동일

## Static Pod 생성

[[k8s docs] Create static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)  
[Static Pod 생성](./create-static-pod.md)

- 일반적인 파드와 동일하게 작성
- 작성된 파일은 반드시 static pod 경로에 위치
- 실행을 위해 별도의 명령은 필요하지 않음
- 작성 후 바로 get pod를 사용하여 확인 가능
