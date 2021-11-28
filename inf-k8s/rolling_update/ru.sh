
# yaml 생성 출력
kubectl run --image alpine:3.4 alpine-deploy --dry-run=client -o yaml

# Deployment 생성 (record=true를 반드시 입력하여 히스토리 기록하여 롤백 기능 사용하도록 한다)
kubectl create -f http-go-deployment.yaml --record=true

kubectl get deployment
kubectl get rs
kubectl get pod 

# rollout을 통해서 상태 확인 가능
# 업데이트 이력을 확인
# 리비전 개수는 디폴트로 10개 까지 저장
kubectl rollout status deployment http-go
kubectl rollout history deploy http-go


```yaml
spec:
  strategy:
    type: RollingUpdate
```

RollingUpdate (default)
- 오래된 포드를 하나씩 제거하는 동시에 새로운 포드 추가
- 요청을 처리할 수 있는 양은 그대로 유지
- 반드시 이전 버전과 새버전을 동시에 처리 가능하도록 설계한 경우에만 사용해야 함

Recreate
- 새 포드를 만들기 전에 이전 포드를 모두 삭제
- 여러 버전을 동시에 실행 불가능
- 잠깐의 다운 타임 존재

# 업데이트 과정을 보기 위해 업데이트 속도 조절
kubectl patch deployment http-go -p '{"spec": {"minReadySeconds": 10}}'




# 업데이트 실행하기
kubectl set image deployment http-go http-go=gasbugs/http-go:v3 --record=true
kubectl edit deploy http-go

# 롤백 하기
kubectl rollout undo deployment http-go
kubectl rollout undo deployment http-go --to-revision=1



# 롤링 업데이트 전략 세부 설정

```yaml
spec:
  processDeadlineSeconds: 600 (default)
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnvailable: 1
```

# maxSurge
- 기본값 25%, 개수로도 설정이 가능
- 최대로 추가 배포를 허용할 개수 설정
- 4개인 경우 25%이면 1개가 설정 (총 개수 5개까지 동시 포드 운영)

# maxUnavailable
- 기본값 25%, 개수로도 설정이 가능
- 동작하지 않는 포드의 개수 설정
- 4개인 경우 25%이면 1개가 설정 (총 개수 4-1개는 운영해야 함)

# processDeadlineSeconds
- 업데이트를 실패하는 경우에는 기본적으로 600초 후에 업데이트를 중지한다.




#  롤아웃 일시중지와 재시작

# 업데이트 중에 일시중지하길 원하는 경우
kubectl rollout pause deployment http-go
# 업데이트 일시중지 중 취소
kubectl rollout undo deployment http-go
# 업데이트 재시작
kubectl rollout resume deployment http-go



# Test
kubectl expose deploy http-go
# 임시 파드 생성
kubectl run -it --rm --image busybox -- bash
```
while true; do wget -O- -q ip.add.re.ss:8080; sleep 1; done
```


