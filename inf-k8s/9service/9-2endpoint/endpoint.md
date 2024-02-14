
# Endpoints

[[k8s docs] Endpoints](https://kubernetes.io/docs/concepts/services-networking/service/#endpoints)
[[k8s docs] Endpoints v1](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/endpoints-v1/)

## 엔드포인트 역할

- 쿠버네티스의 서비스 기능을 사용하면 외부 서비스와도 연결이 가능
- 외부 서비스와 연결을 수행할 때는 서비스의 endpoint를 레이블을 사용해 지정하는 것이 아니라
- 외부 IP를 직접 endpoint라는 별도의 자원에서 설정
- 서비스의 셀렉터 설정이 없는 경우 엔드포인트 오브젝트를 수동으로 추가하여 서비스를 실행중인 네트워크 주소 및 포트에 서비스를 수동으로 매핑

### [레이블이 없는 서비스를 사용하는 사례](https://kubernetes.io/docs/concepts/services-networking/service/#services-without-selectors)

1. 프로덕션 환경에서는 외부 데이터베이스 클러스터를 원하지만 테스트 환경에서는 자체 데이터베이스를 사용하는 경우
2. 서비스가 다른 네임스페이스 또는 다른 클러스터의 서비스를 가리키는 경우
3. 워크로드를 Kubernetes로 마이그레이션하는 경우(접근 방식을 평가하는 동안 쿠버네티스에서 백엔드의 일부 서비스만 실행)

## 엔드포인트 예제

- 엔드포인트를 활용해 `naver.com`과 `malware-traffic-analysis.net`으로 연결하는 서비스를 구성
- nslookup 명령을 사용해 `naver.com`과 `malware-traffic-analysis.net`에 대한 ip 주소 가져옴
- nslookup을 통해 찾은 ip를 서비스와 엔드포인트 yaml에 적용 [my-service-endpoint.yaml](./yaml/my-service-endpoint.yaml)

```bash
nslookup naver.com

Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	naver.com
Address: 223.130.195.95
Name:	naver.com
Address: 223.130.200.104
Name:	naver.com
Address: 223.130.200.107
Name:	naver.com
Address: 223.130.195.200
```

```bash
nslookup www.malware-traffic-analysis.net

Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
www.malware-traffic-analysis.net	canonical name = malware-traffic-analysis.net.
Name:	malware-traffic-analysis.net
Address: 199.201.110.204
```

```bash
kubectl apply -f my-service-endpoint.yaml

service/my-service created
endpoints/my-service created
```

```bash
kubectl get svc

NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
my-service    ClusterIP   10.108.171.236   <none>        80/TCP            11s
```

```bash
kubectl get endpoints

NAME          ENDPOINTS                                                     AGE
my-service    223.130.195.200:80,199.201.110.204:80                         67s
```

wget 또는 curl 호출시 `naver.com`과 `www.malware-traffic-analysis.net`로 라운드로빈 처리되는것을 확인할 수 있다 

```bash
kubectl run -it --rm --image=busybox -- bash
wget -O- -q my-service
```
