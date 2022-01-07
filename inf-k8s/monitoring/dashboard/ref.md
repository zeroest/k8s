
# Kubernetes dashboard

[doc](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

## Install
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
```

## Connect
```bash
kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard 
```
svc 를 NodePort 또는 LoadBalancer 로 설정 하거나 Ingress로 설정하여 외부접근이 가능하게 한다 
가장 좋은 방법은 VPN을 통해 내부에서 접근하여 보안유지를 하도록 한다.

## Token
```bash
kubectl get sa -n kubernetes-dashboard

NAME                   SECRETS   AGE
kubernetes-dashboard   1         49m
```
```bash
kubectl describe sa kubernetes-dashboard -n kubernetes-dashboard

Name:                kubernetes-dashboard
Namespace:           kubernetes-dashboard
Labels:              k8s-app=kubernetes-dashboard
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   kubernetes-dashboard-token-55b5x
Tokens:              kubernetes-dashboard-token-55b5x
Events:              <none>
```
```bash
kubectl get secret -n kubernetes-dashboard

NAME                               TYPE                                  DATA   AGE
default-token-lhpgr                kubernetes.io/service-account-token   3      52m
kubernetes-dashboard-certs         Opaque                                0      52m
kubernetes-dashboard-csrf          Opaque                                1      52m
kubernetes-dashboard-key-holder    Opaque                                2      52m
kubernetes-dashboard-token-55b5x   kubernetes.io/service-account-token   3      52m
```
```bash
kubectl get secret kubernetes-dashboard-token-55b5x -n kubernetes-dashboard -o json | jq -r '.data.token' | base64 -d
```
위 방법은 과정을 모두 나열

```bash
kubectl get secret $(kubectl get sa kubernetes-dashboard -n kubernetes-dashboard -o json | jq -r '.secrets[0].name') -n kubernetes-dashboard -o json | jq -r '.data.token' | base64 -d
```
위 방법은 축약하여 토큰을 가져온다


## Role binding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
```
위 Role binding 을 통해 kubernetes-dashboard는 custer-admin 권한을 가지게 되며
대시보드에서 모든 리소스에 접근이 가능하게 된다

