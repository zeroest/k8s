
# Resource

[doc](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

- cpu와 메모리는 집합적으로 컴퓨팅 리소스 또는 리소스로 부름
- cpu 및 메모리는 각각 자원 유형을 지니며 자원 유형에는 기본 단위를 사용

| 자원 유형  | 단위                   |
| ------     | --------------------   |
| cpu        | m(millicpu)            |
| memory     | Ti,Gi,Mi,Ki, T,G,M,K   |

- cpu는 코어 단위로 지정되며 메모리는 바이트 단위로 지정

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: app
    image: images.my-company.example/app:v4
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
  - name: log-aggregator
    image: images.my-company.example/log-aggregator:v6
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```


