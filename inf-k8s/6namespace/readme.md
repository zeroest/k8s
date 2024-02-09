
# Namespaces

[[k8s docs] Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

- 리소스를 각각의 분리된 영역으로 나누기 좋은 방법
- 여러 네임스페이스를 사용하면 복잡한 쿠버네티스 시스템을 더 작은 그룹으로 분할
- 멀티 테넌트(Multi-tenant) 환경을 분리하여 리소스를 생산, 개발, QA 환경 등으로 사용
- 리소스 이름은 네임스페이스 내에서만 고유 명칭 사용
- 클러스터의 기본 네임스페이스 확인
  - ```bash
    kubectl get ns
    
    NAME              STATUS   AGE
    default           Active   5d23h
    kube-node-lease   Active   5d23h
    kube-public       Active   5d23h
    kube-system       Active   5d23h
    ```

- kubectl 명령을 옵션 없이 사용하면 default 네임스페이스에 질의
- 다른 사용자와 분리된 환경으로 타인의 접근을 제한
- 네임스페이스 별로 리소스 접근 허용과 리소스 양도 제어 가능
- `--namespace`나 `-n`을 사용하여 네임스페이스 별로 확인 가능
  - ```bash
    kubectl get po --namespace kube-system
    ```

- 전체 네임스페이스를 대상으로 kubectl 실행
  - `kubectl get pod --all-namespaces`

## 기본 네임스페이스 설정

`~/.kube/config` 경로에 설정파일에서  
아래 default 네임스페이스를 원하는 네임스페이스로 변경한다
```yaml
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
    namespace: default # 여기에 default namespace를 설정한다.
```
