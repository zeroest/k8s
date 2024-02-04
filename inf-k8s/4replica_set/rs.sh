
# 조회
kubectl get rs
kubectl describe rs rs-nodejs

# 레플리케이션컨트롤러 설정 바꾸기
kubectl edit rs rs-nodejs
# 스케일 변경
kubectl scale rs rs-nodejs --replicas=10

# 삭제
kubectl delete rs rs-nodejs

# 실행 시키고 있는 포드는 계속 실행을 유지하고 싶은 경우에는 --cascade 옵션 사용
# warning: --cascade=false is deprecated (boolean value) and can be replaced with --cascade=orphan.
kubectl delete rs rs-nodejs --cascade=orphan
