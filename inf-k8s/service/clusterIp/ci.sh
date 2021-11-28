
kubectl expose deploy http-go --dry-run=client -o yaml > clusterip.yaml

# 기본적으로 생성시 ClusterIp 방식으로 생성된다 

```
apiVersion: v1
kind: Service
metadata:
  name: http-go-svc
  labels:
    app: http-go-svc
spec:
# sessionAffinity: ClientIP (클라이언트가 스태틱하게 하나의 서버로 설정됨)
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 8080
  - name: https
    port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    app: http-go
```

kubectl get svc
kubectl describe svc http-go-svc



kubectl create deploy http-go --image=gasbugs/http-go --dry-run=client -o yaml > http-go-deploy.yaml
kubectl expose deploy http-go --dry-run=client -o yaml >> http-go-deploy.yaml


