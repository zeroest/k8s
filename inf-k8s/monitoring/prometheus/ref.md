
# Prometheus

[ref](https://blog.naver.com/isc0304/222515904650)


```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```
헬름 레파지토리 추가 

```bash
cat <<EOF > values-prometheus.yaml
server:
  enabled: true

  persistentVolume:
    enabled: true
    accessModes:
      - ReadWriteOnce
    mountPath: /data
    size: 100Gi
  replicaCount: 1

  ## Prometheus data retention period (default if not specified is 15 days)
  ##
  retention: "15d"
  
  tolerations:
  - key: service
    value: buffer
    effect: NoSchedule
    operator: Equal

alertmanager:
  tolerations:
    - key: service
      value: buffer
      operator: Equal
      effect: NoSchedule
  
pushgateway:
  tolerations:
    - key: service
      value: buffer
      operator: Equal
      effect: NoSchedule

EOF
```
Prometheus values 파일 정의
pv를 통한 스토리지 구성 15일간 데이터를 보존


```bash
cat << EOF > values-grafana.yaml
replicas: 1

service:
  type: LoadBalancer

persistence:
  type: pvc
  enabled: true
  # storageClassName: default
  accessModes:
    - ReadWriteOnce
  size: 10Gi
  # annotations: {}
  finalizers:
    - kubernetes.io/pvc-protection

# Administrator credentials when not using an existing secret (see below)
adminUser: admin
adminPassword: test1234!234

tolerations:
- key: service
  value: buffer
  effect: NoSchedule
  operator: Equal

EOF
```
Grafana values 파일 정의
pvc 스토리지를 통해 설정정보를 유지


```bash
kubectl create ns prometheus
helm install prometheus prometheus-community/prometheus -f values-prometheus.yaml -n prometheus
helm install grafana grafana/grafana -f values-grafana.yaml -n prometheus
```
헬름으로 배포를 시작한다.

[dashboard-template](https://grafana.com/grafana/dashboards/13770)


