
# 새로운 레이블을 추가
kubectl label pod ${pod_name} test=foo

# 기존의 레이블을 수정
kubectl label pod ${pod_name} rel=beta --overwrite

# 레이블 삭제 
kubectl label pod ${pod_name} rel-

# 레이블 확인 
kubectl get pod --show-labels

# 특정 레이블 컬럼으로 확인 
kubectl get pod -L app,rel


# 레이블로 필터링하여 검색
kubectl get pod --show-labels -l 'env'
kubectl get pod --show-labels -l '!env'
kubectl get pod --show-labels -l 'env=test'
kubectl get pod --show-labels -l 'env!=test,rel=beta'
