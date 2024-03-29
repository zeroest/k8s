
# 조회
kubectl get rc
kubectl describe rc rc-nodejs

# 레플리케이션컨트롤러 설정 바꾸기
kubectl edit rc rc-nodejs
# 스케일 변경
kubectl scale rc rc-nodejs --replicas=10

# 삭제
kubectl delete rc rc-nodejs

# 실행 시키고 있는 포드는 계속 실행을 유지하고 싶은 경우에는 --cascade 옵션 사용
# warning: --cascade=false is deprecated (boolean value) and can be replaced with --cascade=orphan.
kubectl delete rc rc-nodejs --cascade=orphan
