
# yaml 파일을 직접 수정하여 replicas 수 조정
kubectl edit deploy ${deploy_name}
# 명령을 통해 replicas 수 조정 
kubectl scale deploy ${deploy_name} --replicas=${number} 

