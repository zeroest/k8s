
# Services

[[k8s docs] Service](https://kubernetes.io/docs/concepts/services-networking/service/)  
[[gun_123] 쿠버네티스 서비스 타입](https://velog.io/@gun_123/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%84%9C%EB%B9%84%EC%8A%A4-%ED%83%80%EC%9E%85)  

포드의 문제점
- 포드는 일시적으로 생성한 컨테이너의 집합
- 때문에 포드가 지속적으로 생겨났을 때 서비스를 하기에 적합하지 않음
- IP 주소의 지속적인 변동, 로드밸런싱을 관리해줄 또 다른 개체가 필요
- 이 문제를 해결하기 위해 서비스라는 리소스가 존재

## 서비스의 요구사항
- 외부 클라이언트가 몇 개이든지 프론트엔드 포드로 연결
- 프론트엔드는 다시 백엔드 데이터베이스로 연결
- 포드의 IP가 변경될 때마다 재설정 하지 않도록 해야함

## Service type

[[k8s docs] Service type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)

1. [ClusterIP](./clusterIp)
2. [NodePort](./nodeport)
3. [LoadBalancer](./loadbalancer)
4. ExternalName
5. Headless
6. Ingress

## 서비스 세션 고정

- 서비스가 다수의 포드로 구성하면 웹서비스의 세션이 유지되지 않음
- 이를 위해 처음 들어왔던 클라이언트 IP를 그대로 유지해주는 방법 필요
- sessionAffinity: ClientIP라는 옵션을 주면 해결

## 다중 포트 서비스

- `ports` 옵션에 포트들을 나열해서 다중 포트 서비스한다
- 다중 포트 사용시 `ports` 내 `name` 설정이 필수
  - ```log
    The Service "http-go-svc" is invalid:
    * spec.ports[0].name: Required value
    ```

## 서비스 세부 정보 확인

서비스 세부 사항에 연결될 IP에 대한 정보 존재
```bash
kubectl describe svc http-go-svc

Name:              http-go-svc
Namespace:         default
Labels:            app=http-go-svc
Annotations:       <none>
Selector:          app=http-go
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.100.163.228
IPs:               10.100.163.228
Port:              http  80/TCP
TargetPort:        8080/TCP
Endpoints:         10.0.0.155:8080,10.0.2.142:8080,10.0.2.163:8080
Port:              origin  8080/TCP
TargetPort:        8080/TCP
Endpoints:         10.0.0.155:8080,10.0.2.142:8080,10.0.2.163:8080
Session Affinity:  None
Events:            <none>
```

## 외부 IP 연결 설정

- Service와 Endpoints 리소스 모두 생성 필요
- [Endpoint 참고](./endpoint)
