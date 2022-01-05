
# Resource Quota

[docs](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

## 네임스페이스별 리소스 제한
- 제한하기 원하는 네임스페이스에 ResourceQuota 리소스 생성
- 모든 컨테이너에는 cpu, 메모리에 대한 최소요구사항 및 제한 설정이 필요

---

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: mem-cpu-demmo
spec:
  hard:
    requests.cpu: 1
    requests.memory: 1Gi
    limits.cpu: 2
    limits.memory: 2Gi

```

