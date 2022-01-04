
# config from secret

[doc](https://kubernetes.io/docs/concepts/configuration/secret/)

> Opaque secrets
> Opaque is the default Secret type if omitted from a Secret configuration file. When you create a Secret using kubectl, you will use the generic subcommand to indicate an Opaque Secret type. For example, the following command creates an empty Secret of type Opaque.

```bash
echo -n admin > id.txt
echo -n passw0rd > pw.txt

kubectl create secret generic db-user-pass --from-file=id --from-file=pw
kubectl create secret generic db-user-pass -o yaml > user-pass-secret.yaml
```

```bash
# 직접 입력시 base64 인코딩해서 입력할것
echo -n admin | base64

# 출력시 base64 디코딩해서 원문으로 출력
kubectl get secret db-user-pass -o json | jq --raw-output .data.id | base64 -d
kubectl get secret db-user-pass -o json | jq -r .data.id | base64 -d
```

