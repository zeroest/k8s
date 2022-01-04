
# Multi Container

> Sidecar Container 

- 하나의 포드를 사용하는 경우 같은 네트워크 인터페이스와 IPC, 볼륨 등을 공유
- 이 포드는 효율적으로 통신하여 데이터의 지역성을 보장하고 여러 개의 응용프로그램이 결합된 형태로 하나의 포드를 구성할 수 있음

```bash
kubectl run --image nginx two-containers --dry-run=client -o yaml > two-containers.yaml
```

