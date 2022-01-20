
# Vault
## Init

- vault 상태 확인 
```bash
kubectl exec -it vault-0 -- vault status
```

- vault pod status
```bash
kubectl get pod -n vault 

NAME                                        READY   STATUS    RESTARTS   AGE
pod/vault-0                                 0/1     Running   0          5m41s
```
Running 상태이지만 READY가 되지 않았음을 확인할 수 있다.

- vault init
```bash
kubectl exec -it vault-0 -- vault operator init

Unseal Key 1: MBFSDepD9E6whREc6Dj+k3pMaKJ6cCnCUWcySJQymObb
Unseal Key 2: zQj4v22k9ixegS+94HJwmIaWLBL3nZHe1i+b/wHz25fr
Unseal Key 3: 7dbPPeeGGW3SmeBFFo04peCKkXFuuyKc8b2DuntA4VU5
Unseal Key 4: tLt+ME7Z7hYUATfWnuQdfCEgnKA2L173dptAwfmenCdf
Unseal Key 5: vYt9bxLr0+OzJ8m7c7cNMFj7nvdLljj0xWRbpLezFAI9

Initial Root Token: s.zJNwZlRrqISjyBHFMiEca6GF
```
> Initialize one Vault server with the default number of key shares and default key threshold
> The output displays the key shares and initial root key generated.

- Unseal the Vault server with the key shares until the key threshold is met:

```bash
kubectl exec -it vault-0 -- vault operator unseal ${UNSEAL-KEY-1}
kubectl exec -it vault-0 -- vault operator unseal ${UNSEAL-KEY-2}
kubectl exec -it vault-0 -- vault operator unseal ${UNSEAL-KEY-3}
```

```bash
kubectl get pod -n vault

NAME                                        READY   STATUS    RESTARTS   AGE
pod/vault-0                                 1/1     Running   0          10m
```
> Repeat the unseal process for all Vault server pods. When all Vault server pods are unsealed they report READY 1/1.



