
# Vault 

## Install

[doc](https://www.vaultproject.io/docs/platform/k8s/helm/run)

- helm 레파지토리 추가
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
```

- vault 가 존재하는지 확인한다.
```bash
helm search repo hashicorp/vault
helm search repo hashicorp/vault -l
# latest 버전이 아닌 이전 버전을 확인한다.
```

- The Helm chart may run a Vault server in development. This installs a single Vault server with a memory storage backend.
```bash
helm install vault hashicorp/vault \
   --set "server.dev.enabled=true"
```

- override 할 설정 yaml 파일
```bash
cat <<EOF > values.yaml
server:
  ha:
    enabled: true
    replicas: 2
EOF
```

- yaml 파일로 vault를 배포한다.
```bash
kubectl create ns vault

helm install vault hashicorp/vault \
    --values values.yaml \
    --namespace vault
```

- Install the latest Vault Helm chart in standalone mode.
  - The Helm chart defaults to run in standalone mode. This installs a single Vault server with a file storage backend.
```
helm install vault hashicorp/vault
```

- Install the latest Vault Helm chart in HA mode.
  - The Helm chart may be run in high availability (HA) mode. This installs three Vault servers with an existing Consul storage backend. It is suggested that Consul is installed via the Consul Helm chart.
```bash
helm install vault hashicorp/vault \
   --set "server.ha.enabled=true"
```



