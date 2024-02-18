
# Ingress

[[k8s docs] Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)  
[[k8s docs] Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)  

[[devopscube] Kubernetes Ingress Tutorial For Beginners](https://devopscube.com/kubernetes-ingress-tutorial/)  

하나의 IP 또는 도메인으로 다수의 서비스 제공

![Ingress workflow](img/ingress-workflow.png)

## [Path types](https://kubernetes.io/docs/concepts/services-networking/ingress/#examples)

- ImplementationSpecific: With this path type, matching is up to the IngressClass. Implementations can treat this as a separate pathType or treat it identically to Prefix or Exact path types.
- Exact: Matches the URL path exactly and with case sensitivity.
- Prefix: Matches based on a URL path prefix split by /. Matching is case sensitive and done on a path element by element basis. A path element refers to the list of labels in the path split by the / separator. A request is a match for path p if every p is an element-wise prefix of p of the request path.

## [Nginx Ingress Controller](https://github.com/kubernetes/ingress-nginx)

![Nginx ingress controller](img/nginx-ingress-controller.svg)

- 프라이빗 환경에서 인그레스를 사용할 수 있는 ingress-nginx 설치
- 쿠버네티스에 파드 형태로 띄워서 설정하는 방법
- nginx-ingress가 파드로 떠있으면서 다시 서비스로 연결할 수 있는 역할을 수행

### [Nginx ingress 설치](https://kubernetes.github.io/ingress-nginx/deploy/)

```bash
git clone https://github.com/kubernetes/ingress-nginx/
kubectl apply -k `pwd`/ingress-nginx/deploy/static/provider/baremetal/
# kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io ingress-nginx-admission
# webhook 구성 삭제 명령
# webhook 기능으로 ingress가 정상적으로 동작되지 않는 현상이 있음
```

```bash
kubectl get all -n ingress-nginx

NAME                                            READY   STATUS      RESTARTS   AGE
pod/ingress-nginx-admission-create-5gscm        0/1     Completed   0          2m26s
pod/ingress-nginx-admission-patch-kbmtk         0/1     Completed   1          2m26s
pod/ingress-nginx-controller-55754d7d8b-gc8lp   1/1     Running     0          2m26s

NAME                                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
service/ingress-nginx-controller             NodePort    10.102.208.171   <none>        80:31266/TCP,443:31547/TCP   2m26s
service/ingress-nginx-controller-admission   ClusterIP   10.109.205.23    <none>        443/TCP                      2m26s

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ingress-nginx-controller   1/1     1            1           2m26s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/ingress-nginx-controller-55754d7d8b   1         1         1       2m26s

NAME                                       COMPLETIONS   DURATION   AGE
job.batch/ingress-nginx-admission-create   1/1           7s         2m26s
job.batch/ingress-nginx-admission-patch    1/1           8s         2m26s
```

### Ingress 테스트

```bash
kubectl apply -f http-go-ingress.yaml
```

```bash
kubectl get ing
kubectl get ing -o yaml

NAME              CLASS   HOSTS   ADDRESS         PORTS   AGE
http-go-ingress   nginx   *       192.168.0.108   80      4m47s
```

```bash
# kubectl apply -f http-go-deploy.yaml
kubectl create deployment http-go --image=gasbugs/http-go:ingress
kubectl expose deployment http-go --port=80 --target-port=8080 # --type=NodePort
```

```bash
curl 127.0.0.1:31266 # (service/ingress-nginx-controller)
curl 10.102.208.171 # (service/ingress-nginx-controller)

<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

```bash
curl 127.0.0.1:31266/welcome/test
curl 10.102.208.171/welcome/test

Welcome! http-go-7fd8fc8d7b-qlshc
```

## Ingress TLS

[[k8s docs] Ingress TLS](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls)

TLS 인증서 생성

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -out ingress-tls.crt \
  -keyout ingress-tls.key \
  -subj "/CN=ingress-tls"
  
Generating a RSA private key
.........+++++
..........+++++
writing new private key to 'ingress-tls.key'
-----
```

```bash
ll

-rw-rw-r-- 1 ubuntu ubuntu 1119 Feb 18 04:40 ingress-tls.crt
-rw------- 1 ubuntu ubuntu 1708 Feb 18 04:40 ingress-tls.key
```

쿠버네티스의 Secret 이라는 보안관련 저장소에 위 개인키와 인증서를 등록해둔다

[TLS Secret yaml](./yaml/http-go-ingress-tls-secret.yaml)
```bash
kubectl create secret tls ingress-tls \
  --namespace default \
  --key ingress-tls.key \
  --cert ingress-tls.crt

secret/ingress-tls created
```

```bash
kubectl get secret

NAME          TYPE                DATA   AGE
ingress-tls   kubernetes.io/tls   2      2m37s
```

TLS 인증서를 사용하는 Ingress 생성

[Ingress TLS setup yaml](./yaml/http-go-ingress-tls.yaml)
```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: http-go-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /welcome/test
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  # TLS 설정
  tls:
    - hosts:
        - zeroest.me
      secretName: ingress-tls
  rules:
    - host: zeroest.me
      http:
        paths:
          - pathType: Exact
            path: /welcome/test
            backend:
              service:
                name: http-go
                port:
                  number: 80
EOF
```

```bash
kubectl get svc -n ingress-nginx

NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.102.208.171   <none>        80:31266/TCP,443:31547/TCP   45h
ingress-nginx-controller-admission   ClusterIP   10.109.205.23    <none>        443/TCP                      45h
```

- `-k`: `--insecure` https 사이트를 SSL certificate 검증없이 연결한다.
- `-v`: `--verbose` 자세한 로그 출력
- `--resolve`: 도메인 캐시를 실시간으로 등록하면서 curl 명령어 사용 

```bash
curl http://zeroest.me:31266/welcome/test -kv --resolve zeroest.me:31266:127.0.0.1

* Added zeroest.me:31266:127.0.0.1 to DNS cache
* Hostname zeroest.me was found in DNS cache
*   Trying 127.0.0.1:31266...
* TCP_NODELAY set
* Connected to zeroest.me (127.0.0.1) port 31266 (#0)
> GET /welcome/test HTTP/1.1
> Host: zeroest.me:31266
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 308 Permanent Redirect
< Date: Sun, 18 Feb 2024 14:41:56 GMT
< Content-Type: text/html
< Content-Length: 164
< Connection: keep-alive
< Location: https://zeroest.me/welcome/test
<
<html>
<head><title>308 Permanent Redirect</title></head>
<body>
<center><h1>308 Permanent Redirect</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host zeroest.me left intact
```

```bash
curl https://zeroest.me:31547/welcome/test -kv --resolve zeroest.me:31547:127.0.0.1

* Added zeroest.me:31547:127.0.0.1 to DNS cache
* Hostname zeroest.me was found in DNS cache
*   Trying 127.0.0.1:31547...
* TCP_NODELAY set
* Connected to zeroest.me (127.0.0.1) port 31547 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
*  start date: Feb 16 16:44:29 2024 GMT
*  expire date: Feb 15 16:44:29 2025 GMT
*  issuer: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x55863f92c0e0)
> GET /welcome/test HTTP/2
> Host: zeroest.me:31547
> user-agent: curl/7.68.0
> accept: */*
>
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
< HTTP/2 200
< date: Sun, 18 Feb 2024 14:42:40 GMT
< content-type: text/plain; charset=utf-8
< content-length: 34
< strict-transport-security: max-age=31536000; includeSubDomains
<
Welcome! http-go-7fd8fc8d7b-dv57w
* Connection #0 to host zeroest.me left intact
```
