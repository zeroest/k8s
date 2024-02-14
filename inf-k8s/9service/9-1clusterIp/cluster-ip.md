
# Cluster IP

ClusterIP 서비스 타입은 쿠버네티스 클러스터 내에서만 접근 가능한 내부 서비스를 생성합니다.  
이 서비스 타입은 서비스에 고정된 IP 주소를 할당하며, 클러스터의 다른 파드들이 이 IP 주소를 사용하여 서비스에 접근할 수 있습니다.  
외부 네트워크에서는 이 서비스에 접근할 수 없으며, 클러스터 내에서만 사용되는 경우에 적합합니다.  

```bash
kubectl create deploy --image=gasbugs/http-go http-go --dry-run=client -o yaml > http-go-deploy.yaml
```

kubectl의 expose 명령어를 통한 서비스 생성

```bash
kubectl expose deploy http-go --port=80 --dry-run=client -o yaml > http-go-svc.yaml
```

기본적으로 type 지정하지 않고 생성시 ClusterIp 방식으로 생성된다

```yaml
apiVersion: v1
kind: Service
metadata:
  name: http-go-svc
  labels:
    app: http-go-svc
spec:
#  type: ClusterIP # 별도 지정 없이 적용시 기본 ClusterIP 설정됨
#  sessionAffinity: ClientIP # (클라이언트가 스태틱하게 하나의 서버로 설정됨)
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
