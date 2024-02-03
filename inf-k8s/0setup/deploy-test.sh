#!/bin/bash

kubectl create deploy tc --image=consol/tomcat-7.0 --replicas=5
kubectl expose deploy tc --type=NodePort --port=80 --target-port=8080
kubectl get pod,svc

# NAME                      READY   STATUS    RESTARTS   AGE
# pod/tc-5864958cfd-5vrh2   1/1     Running   0          61s
# pod/tc-5864958cfd-bfm54   1/1     Running   0          61s
# pod/tc-5864958cfd-bjbv5   1/1     Running   0          61s
# pod/tc-5864958cfd-hqbk4   1/1     Running   0          61s
# pod/tc-5864958cfd-pjll7   1/1     Running   0          61s
# NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        33m
# service/tc           NodePort    10.99.202.142   <none>        80:31080/TCP   13s

curl k8s-03:31080

kubectl scale deploy tc --replicas=3
kubectl delete all --all