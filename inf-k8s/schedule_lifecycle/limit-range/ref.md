
# Limit Ranges

[docs](https://kubernetes.io/docs/concepts/policy/limit-range/)

- 네임스페이스에서 포드 또는 컨테이너별로 리소스를 제한하는 정책

## 기능

- namespace에서 포드나 컨테이너당 최소 및 최대 컴퓨팅 리소스 사용량 제한
- namespace에서 PersistentVolumeClaim 당 최소 및 최대 스토리지 사용량 제한
- namespace에서 리소스에 대한 요청과 제한 사이의 비율 적용
- namespace에서 컴퓨팅 리소스에 대한 디폴트 request/limit을 설정하고 런타임 중인 컨테이너에 자동으로 입력

## 적용

- api-server 옵션으로 --enable-admission-plugins=LimitRange 설정 
- 클라우드의 경우 해당 클라우드 설정에 따라 다를 수 있다

```bash
sudo vim /etc/kubernetes/manifests/kube-apiserver.yaml

spec.containers.command.enalbe-admission-plugins=NodeRestriction,LimitRange
```

---

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: limit-container
spec:
  limits:
  - default:		# default max value
      cpu: 100m
      memory: 500Mi
    defaultRequest:	# default min value
      cpu: 100m
      memory: 256Mi
    max:
      cpu: 100m
      memory: 256Mi
    min:
      cpu: 100m
      memory: 256Mi
    type: Container
# Pod, PersistentVolumeClaim(storage) 
```

