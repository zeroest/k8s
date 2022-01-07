
# HPA
Horizontal Pod Autoscaler

- HPA(Horizontal): 포드 자체를 복제하여 처리할 수 있는 포드의 개수를 늘리는 방법
- VPA(Vertical): 리소스를 증가시켜 포드의 사용 가능한 리소스를 늘리는 방법
- CA: 번외로 클러스터 자체를 늘리는 방법(노드 추가)

- 공식 쿠버네티스에서 HPA만 지원
- VPA, CA는 클라우드 서비스의 도움을 통해 제공

---


```bash
kubectl apply -f https://k8s.io/examples/application/php-apache.yaml

kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10 -o yaml --dry-run=client

kubectl get hpa -w

kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
while true; do wget -O- http://php.apache.default.svc.cluster.local; done;
```

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Pods
    pods:
      metric:
        name: packets-per-second
      target:
        type: AverageValue
        averageValue: 1k
  - type: Object
    object:
      metric:
        name: requests-per-second
      describedObject:
        apiVersion: networking.k8s.io/v1beta1
        kind: Ingress
        name: main-route
      target:
        type: Value
        value: 10k
```

