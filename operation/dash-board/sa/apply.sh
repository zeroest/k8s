
#!/bin/bash

kubectl apply -f dashboard-adminuser.yaml
# 서비스 어카운트 생성

kubectl apply -f rollbinding.yaml
# 위에서 생성한 서비스 어카운트를 매핑

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
# 서비스 어카운트의 토큰 확인

