
# 롤링 업데이트 테스트

업데이트에 실패하는 케이스
- 부족한 할당량(Insufficient quota)
- 레디네스 프로브 실패(Readiness probe failures)
- 권한 부족(Insufficient permissions)
- 제한 범위(Limit ranges)
- 응용 프로그램 런타임 구성 오류(Application runtime misconfiguration)
- 업데이트에 실패하는 경우 기본 600초 후에 업데이트를 중지한다
  - ```yaml
    spec:
      processDeadlineSeconds: 600
    ```

## Rollout 히스토리 기록

디플로이먼트 생성시 `--record=true` 옵션을 주어 히스토리 변경에 대한 기록이 남는다

```bash
kubectl apply[create] -f http-go-deployment.yaml --record=true
kubectl rollout status deploy http-go
kubectl rollout history deploy http-go 
```
```
--record=true 없을 경우 
deployment.apps/http-go
REVISION  CHANGE-CAUSE
1         <none>

--record=true 적용시
deployment.apps/http-go
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=http-go-v1.yaml --record=true
```

## 업데이트

업데이트 과정을 보기 위해 업데이트 속도 조절
```bash
kubectl patch deployment http-go -p '{"spec": {"minReadySeconds": 10}}'
```

로드 벨런싱 할 서비스 생성
```bash
kubectl expose deploy http-go
kubectl get svc

NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
http-go      ClusterIP   10.103.247.224   <none>        8080/TCP   26s
```

빈 컨테이너를 생성해서 해당 컨테이너에서 위 CLUSTER-IP로 curl 호출 하도록 한다
```bash
kubectl run -it --rm --image busybox -- bash

# 호출 테스트
curl 10.103.247.224:8080
or
wget -O- -q 10.103.247.224:8080

# 디플로이먼트를 모니터 하는 프로그램 실행
while true; do wget -O- -q 10.103.247.224:8080; sleep 1; done
```

새로운 터미널을 열어 이미지 업데이트 실행  
`--record=true` 옵션으로 히스토리 남기도록 하자  
```bash
kubectl set image deployment http-go http-go=gasbugs/http-go:v2 --record=true
```

업데이트한 이력을 확인  
리비전의 개수는 디폴트로 10개까지 저장  
```bash
kubectl rollout history deployment http-go

deployment.apps/http-go
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=http-go-v1.yaml --record=true
2         kubectl set image deployment http-go http-go=gasbugs/http-go:v2 --record=true
```

레플리카셋을 새로 만들어 적용하고 기존 레플리카셋은 백업으로 남겨둔다  
설정이 겹치는 레플리카셋은 그대로 재활용 한다
```bash
kubectl get rs

NAME                 DESIRED   CURRENT   READY   AGE
http-go-5f4d98f6d5   0         0         0       82m
http-go-7d7bd59cf4   3         3         3       21m
```

edit 명령어를 통한 업데이트
```bash
kubectl edit deploy http-go --record=true
```

```bash
kubectl get rs

NAME                 DESIRED   CURRENT   READY   AGE
http-go-5f4d98f6d5   0         0         0       84m
http-go-7d7bd59cf4   3         3         3       23m
http-go-5dbf76cb99   1         1         0       5s
```

```bash
kubectl rollout history deploy http-go

deployment.apps/http-go
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=http-go-v1.yaml --record=true
2         kubectl set image deployment http-go http-go=gasbugs/http-go:v2 --record=true
3         kubectl edit deploy http-go --record=true
```

## 롤백

롤백을 실행하면 이전 업데이트 상태로 돌아감  
롤백을 하여도 히스토리의 리비전 상태는 이전 상태로 돌아가지 않음  
```bash
# kubectl set image deployment http-go http-go=gasbugs/http-go:v3

kubectl rollout undo deployment http-go

kubectl exec http-go-hash -- curl 127.0.0.1:8080

# 특정 버전으로 롤백
kubectl rollout undo deployment http-go --to-revision=1
```

undo 를 통해 롤백시 이전 버전이었던 2번 리비전이 최신 리비전으로 적용된다
```bash
kubectl rollout history deploy http-go

deployment.apps/http-go
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=http-go-v1.yaml --record=true
3         kubectl edit deploy http-go --record=true
4         kubectl set image deployment http-go http-go=gasbugs/http-go:v2 --record=true
```

레플리카셋 또한 이전 레플리카셋을 재사용하는 것을 볼 수 있다
```bash
kubectl get rs

NAME                 DESIRED   CURRENT   READY   AGE
http-go-5dbf76cb99   0         0         0       3m23s
http-go-5f4d98f6d5   0         0         0       87m
http-go-7d7bd59cf4   3         3         3       26m
```

리비전을 통해 특정 버전으로 롤백
```bash
kubectl rollout undo deploy http-go --to-revision=1
```

1번 리비전이 가장 최신 리비전인 5번으로 변경된 모습을 볼 수 있다
```bash
kubectl rollout history deploy http-go

deployment.apps/http-go
REVISION  CHANGE-CAUSE
3         kubectl edit deploy http-go --record=true
4         kubectl set image deployment http-go http-go=gasbugs/http-go:v2 --record=true
5         kubectl apply --filename=http-go-v1.yaml --record=true
```

```bash
kubectl get rs

NAME                 DESIRED   CURRENT   READY   AGE
http-go-5dbf76cb99   0         0         0       7m10s
http-go-5f4d98f6d5   1         1         1       91m
http-go-7d7bd59cf4   3         3         3       30m
```

## 롤아웃 컨트롤

업데이트 중에 일시정지
```bash
kubectl rollout pause deployment http-go
```

업데이트 일시중지 중 취소  
다시 이전 버전으로 전환
```bash
kubectl rollout undo deployment http-go
```

업데이트 재시작
```bash
kubectl rollout resume deployment http-go
```
