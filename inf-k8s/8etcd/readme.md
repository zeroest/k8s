
# ETCD

[etcd official docs](https://etcd.io/)  
[etcd github](https://github.com/etcd-io/etcd)

[[kakao tech] Kubernetes 운영을 위한 etcd 기본 동작 원리의 이해](https://tech.kakao.com/2021/12/20/kubernetes-etcd/)

A distributed, reliable key-value store for the most critical data of a distributed system

다중 key-value 데이터 셋

## ETCD 클라이언트 테스트

쿠버네티스에서 동작중인 etcd 서버에 직접 다운받은 `etcdctl` 을 사용해서 클라이언트로 접속해본다

https://github.com/etcd-io/etcd/releases 에서 최신 버전 다운로드

```bash
wget https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz
tar xvzf etcd-v3.5.12-linux-amd64.tar.gz
cd etcd-v3.5.12-linux-amd64/
```

kubernetes 는 기본적으로 ssl 통신을 기반으로 하기 때문에 쿠버네티스의 cacert를 입력하여 통신하도록 한다

certificate 와 개인키 퍼블릭키 등이 필요함

쿠버네티스에서 필요한 secrets, roles 등 민감한 정보들을 담고있다

```bash
sudo ETCDCTL_API=3 \ # API 버전 설정
  ./etcdctl \
  --endpoints 127.0.0.1:2379 \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  get / --prefix --keys-only
  
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumcidrgroups.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumclusterwidenetworkpolicies.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumendpoints.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumexternalworkloads.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumidentities.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliuml2announcementpolicies.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumloadbalancerippools.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumnetworkpolicies.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumnodeconfigs.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumnodes.cilium.io
/registry/apiextensions.k8s.io/customresourcedefinitions/ciliumpodippools.cilium.io
/registry/apiregistration.k8s.io/apiservices/v1.
/registry/apiregistration.k8s.io/apiservices/v1.admissionregistration.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.apiextensions.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.apps
/registry/apiregistration.k8s.io/apiservices/v1.authentication.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.autoscaling
/registry/apiregistration.k8s.io/apiservices/v1.batch
/registry/apiregistration.k8s.io/apiservices/v1.certificates.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.coordination.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.discovery.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.events.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.networking.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.node.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.policy
/registry/apiregistration.k8s.io/apiservices/v1.rbac.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.scheduling.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.storage.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta2.flowcontrol.apiserver.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta3.flowcontrol.apiserver.k8s.io
/registry/apiregistration.k8s.io/apiservices/v2.autoscaling
/registry/apiregistration.k8s.io/apiservices/v2.cilium.io
/registry/apiregistration.k8s.io/apiservices/v2alpha1.cilium.io
/registry/cilium.io/ciliumendpoints/kube-system/coredns-5dd5756b68-nvcjv
/registry/cilium.io/ciliumendpoints/kube-system/coredns-5dd5756b68-vn5t4
/registry/cilium.io/ciliumidentities/1114
/registry/cilium.io/ciliumidentities/27033
/registry/cilium.io/ciliumnodes/k8s-01
/registry/cilium.io/ciliumnodes/k8s-02
/registry/cilium.io/ciliumnodes/k8s-03
/registry/clusterrolebindings/cilium
/registry/clusterrolebindings/cilium-operator
/registry/clusterrolebindings/cluster-admin
/registry/clusterrolebindings/kubeadm:get-nodes
/registry/clusterrolebindings/kubeadm:kubelet-bootstrap
/registry/clusterrolebindings/kubeadm:node-autoapprove-bootstrap
/registry/clusterrolebindings/kubeadm:node-autoapprove-certificate-rotation
/registry/clusterrolebindings/kubeadm:node-proxier
/registry/clusterrolebindings/system:basic-user
/registry/clusterrolebindings/system:controller:attachdetach-controller
/registry/clusterrolebindings/system:controller:certificate-controller
/registry/clusterrolebindings/system:controller:clusterrole-aggregation-controller
/registry/clusterrolebindings/system:controller:cronjob-controller
/registry/clusterrolebindings/system:controller:daemon-set-controller
/registry/clusterrolebindings/system:controller:deployment-controller
/registry/clusterrolebindings/system:controller:disruption-controller
/registry/clusterrolebindings/system:controller:endpoint-controller
/registry/clusterrolebindings/system:controller:endpointslice-controller
/registry/clusterrolebindings/system:controller:endpointslicemirroring-controller
/registry/clusterrolebindings/system:controller:ephemeral-volume-controller
/registry/clusterrolebindings/system:controller:expand-controller
/registry/clusterrolebindings/system:controller:generic-garbage-collector
/registry/clusterrolebindings/system:controller:horizontal-pod-autoscaler
/registry/clusterrolebindings/system:controller:job-controller
/registry/clusterrolebindings/system:controller:namespace-controller
/registry/clusterrolebindings/system:controller:node-controller
/registry/clusterrolebindings/system:controller:persistent-volume-binder
/registry/clusterrolebindings/system:controller:pod-garbage-collector
/registry/clusterrolebindings/system:controller:pv-protection-controller
/registry/clusterrolebindings/system:controller:pvc-protection-controller
/registry/clusterrolebindings/system:controller:replicaset-controller
/registry/clusterrolebindings/system:controller:replication-controller
/registry/clusterrolebindings/system:controller:resourcequota-controller
/registry/clusterrolebindings/system:controller:root-ca-cert-publisher
/registry/clusterrolebindings/system:controller:route-controller
/registry/clusterrolebindings/system:controller:service-account-controller
/registry/clusterrolebindings/system:controller:service-controller
/registry/clusterrolebindings/system:controller:statefulset-controller
/registry/clusterrolebindings/system:controller:ttl-after-finished-controller
/registry/clusterrolebindings/system:controller:ttl-controller
/registry/clusterrolebindings/system:coredns
/registry/clusterrolebindings/system:discovery
/registry/clusterrolebindings/system:kube-controller-manager
/registry/clusterrolebindings/system:kube-dns
/registry/clusterrolebindings/system:kube-scheduler
/registry/clusterrolebindings/system:monitoring
/registry/clusterrolebindings/system:node
/registry/clusterrolebindings/system:node-proxier
/registry/clusterrolebindings/system:public-info-viewer
/registry/clusterrolebindings/system:service-account-issuer-discovery
/registry/clusterrolebindings/system:volume-scheduler
/registry/clusterroles/admin
/registry/clusterroles/cilium
/registry/clusterroles/cilium-operator
/registry/clusterroles/cluster-admin
/registry/clusterroles/edit
/registry/clusterroles/kubeadm:get-nodes
/registry/clusterroles/system:aggregate-to-admin
/registry/clusterroles/system:aggregate-to-edit
/registry/clusterroles/system:aggregate-to-view
/registry/clusterroles/system:auth-delegator
/registry/clusterroles/system:basic-user
/registry/clusterroles/system:certificates.k8s.io:certificatesigningrequests:nodeclient
/registry/clusterroles/system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
/registry/clusterroles/system:certificates.k8s.io:kube-apiserver-client-approver
/registry/clusterroles/system:certificates.k8s.io:kube-apiserver-client-kubelet-approver
/registry/clusterroles/system:certificates.k8s.io:kubelet-serving-approver
/registry/clusterroles/system:certificates.k8s.io:legacy-unknown-approver
/registry/clusterroles/system:controller:attachdetach-controller
/registry/clusterroles/system:controller:certificate-controller
/registry/clusterroles/system:controller:clusterrole-aggregation-controller
/registry/clusterroles/system:controller:cronjob-controller
/registry/clusterroles/system:controller:daemon-set-controller
/registry/clusterroles/system:controller:deployment-controller
/registry/clusterroles/system:controller:disruption-controller
/registry/clusterroles/system:controller:endpoint-controller
/registry/clusterroles/system:controller:endpointslice-controller
/registry/clusterroles/system:controller:endpointslicemirroring-controller
/registry/clusterroles/system:controller:ephemeral-volume-controller
/registry/clusterroles/system:controller:expand-controller
/registry/clusterroles/system:controller:generic-garbage-collector
/registry/clusterroles/system:controller:horizontal-pod-autoscaler
/registry/clusterroles/system:controller:job-controller
/registry/clusterroles/system:controller:namespace-controller
/registry/clusterroles/system:controller:node-controller
/registry/clusterroles/system:controller:persistent-volume-binder
/registry/clusterroles/system:controller:pod-garbage-collector
/registry/clusterroles/system:controller:pv-protection-controller
/registry/clusterroles/system:controller:pvc-protection-controller
/registry/clusterroles/system:controller:replicaset-controller
/registry/clusterroles/system:controller:replication-controller
/registry/clusterroles/system:controller:resourcequota-controller
/registry/clusterroles/system:controller:root-ca-cert-publisher
/registry/clusterroles/system:controller:route-controller
/registry/clusterroles/system:controller:service-account-controller
/registry/clusterroles/system:controller:service-controller
/registry/clusterroles/system:controller:statefulset-controller
/registry/clusterroles/system:controller:ttl-after-finished-controller
/registry/clusterroles/system:controller:ttl-controller
/registry/clusterroles/system:coredns
/registry/clusterroles/system:discovery
/registry/clusterroles/system:heapster
/registry/clusterroles/system:kube-aggregator
/registry/clusterroles/system:kube-controller-manager
/registry/clusterroles/system:kube-dns
/registry/clusterroles/system:kube-scheduler
/registry/clusterroles/system:kubelet-api-admin
/registry/clusterroles/system:monitoring
/registry/clusterroles/system:node
/registry/clusterroles/system:node-bootstrapper
/registry/clusterroles/system:node-problem-detector
/registry/clusterroles/system:node-proxier
/registry/clusterroles/system:persistent-volume-provisioner
/registry/clusterroles/system:public-info-viewer
/registry/clusterroles/system:service-account-issuer-discovery
/registry/clusterroles/system:volume-scheduler
/registry/clusterroles/view
/registry/configmaps/default/kube-root-ca.crt
/registry/configmaps/kube-node-lease/kube-root-ca.crt
/registry/configmaps/kube-public/cluster-info
/registry/configmaps/kube-public/kube-root-ca.crt
/registry/configmaps/kube-system/cilium-config
/registry/configmaps/kube-system/coredns
/registry/configmaps/kube-system/extension-apiserver-authentication
/registry/configmaps/kube-system/kube-apiserver-legacy-service-account-token-tracking
/registry/configmaps/kube-system/kube-proxy
/registry/configmaps/kube-system/kube-root-ca.crt
/registry/configmaps/kube-system/kubeadm-config
/registry/configmaps/kube-system/kubelet-config
/registry/controllerrevisions/kube-system/cilium-647bfbf8cb
/registry/controllerrevisions/kube-system/kube-proxy-dd5cd4cc6
/registry/csinodes/k8s-01
/registry/csinodes/k8s-02
/registry/csinodes/k8s-03
/registry/daemonsets/kube-system/cilium
/registry/daemonsets/kube-system/kube-proxy
/registry/deployments/kube-system/cilium-operator
/registry/deployments/kube-system/coredns
/registry/endpointslices/default/kubernetes
/registry/endpointslices/kube-system/hubble-peer-rq88d
/registry/endpointslices/kube-system/kube-dns-8qkqm
/registry/flowschemas/catch-all
/registry/flowschemas/endpoint-controller
/registry/flowschemas/exempt
/registry/flowschemas/global-default
/registry/flowschemas/kube-controller-manager
/registry/flowschemas/kube-scheduler
/registry/flowschemas/kube-system-service-accounts
/registry/flowschemas/probes
/registry/flowschemas/service-accounts
/registry/flowschemas/system-leader-election
/registry/flowschemas/system-node-high
/registry/flowschemas/system-nodes
/registry/flowschemas/workload-leader-election
/registry/leases/kube-node-lease/k8s-01
/registry/leases/kube-node-lease/k8s-02
/registry/leases/kube-node-lease/k8s-03
/registry/leases/kube-system/apiserver-ajtjqc4z6ay72fvvmk3uh3sbfy
/registry/leases/kube-system/cilium-operator-resource-lock
/registry/leases/kube-system/kube-controller-manager
/registry/leases/kube-system/kube-scheduler
/registry/masterleases/192.168.0.67
/registry/minions/k8s-01
/registry/minions/k8s-02
/registry/minions/k8s-03
/registry/namespaces/default
/registry/namespaces/kube-node-lease
/registry/namespaces/kube-public
/registry/namespaces/kube-system
/registry/pods/default/static-web-k8s-01
/registry/pods/kube-system/cilium-k457h
/registry/pods/kube-system/cilium-operator-684cb65b-b5fwq
/registry/pods/kube-system/cilium-sf762
/registry/pods/kube-system/cilium-xw9j2
/registry/pods/kube-system/coredns-5dd5756b68-nvcjv
/registry/pods/kube-system/coredns-5dd5756b68-vn5t4
/registry/pods/kube-system/etcd-k8s-01
/registry/pods/kube-system/kube-apiserver-k8s-01
/registry/pods/kube-system/kube-controller-manager-k8s-01
/registry/pods/kube-system/kube-proxy-6p2sf
/registry/pods/kube-system/kube-proxy-fs799
/registry/pods/kube-system/kube-proxy-wgsgl
/registry/pods/kube-system/kube-scheduler-k8s-01
/registry/priorityclasses/system-cluster-critical
/registry/priorityclasses/system-node-critical
/registry/prioritylevelconfigurations/catch-all
/registry/prioritylevelconfigurations/exempt
/registry/prioritylevelconfigurations/global-default
/registry/prioritylevelconfigurations/leader-election
/registry/prioritylevelconfigurations/node-high
/registry/prioritylevelconfigurations/system
/registry/prioritylevelconfigurations/workload-high
/registry/prioritylevelconfigurations/workload-low
/registry/ranges/serviceips
/registry/ranges/servicenodeports
/registry/replicasets/kube-system/cilium-operator-684cb65b
/registry/replicasets/kube-system/coredns-5dd5756b68
/registry/rolebindings/kube-public/kubeadm:bootstrap-signer-clusterinfo
/registry/rolebindings/kube-public/system:controller:bootstrap-signer
/registry/rolebindings/kube-system/cilium-config-agent
/registry/rolebindings/kube-system/kube-proxy
/registry/rolebindings/kube-system/kubeadm:kubelet-config
/registry/rolebindings/kube-system/kubeadm:nodes-kubeadm-config
/registry/rolebindings/kube-system/system::extension-apiserver-authentication-reader
/registry/rolebindings/kube-system/system::leader-locking-kube-controller-manager
/registry/rolebindings/kube-system/system::leader-locking-kube-scheduler
/registry/rolebindings/kube-system/system:controller:bootstrap-signer
/registry/rolebindings/kube-system/system:controller:cloud-provider
/registry/rolebindings/kube-system/system:controller:token-cleaner
/registry/roles/kube-public/kubeadm:bootstrap-signer-clusterinfo
/registry/roles/kube-public/system:controller:bootstrap-signer
/registry/roles/kube-system/cilium-config-agent
/registry/roles/kube-system/extension-apiserver-authentication-reader
/registry/roles/kube-system/kube-proxy
/registry/roles/kube-system/kubeadm:kubelet-config
/registry/roles/kube-system/kubeadm:nodes-kubeadm-config
/registry/roles/kube-system/system::leader-locking-kube-controller-manager
/registry/roles/kube-system/system::leader-locking-kube-scheduler
/registry/roles/kube-system/system:controller:bootstrap-signer
/registry/roles/kube-system/system:controller:cloud-provider
/registry/roles/kube-system/system:controller:token-cleaner
/registry/secrets/kube-system/cilium-ca
/registry/secrets/kube-system/hubble-server-certs
/registry/secrets/kube-system/sh.helm.release.v1.cilium.v1
/registry/serviceaccounts/default/default
/registry/serviceaccounts/kube-node-lease/default
/registry/serviceaccounts/kube-public/default
/registry/serviceaccounts/kube-system/attachdetach-controller
/registry/serviceaccounts/kube-system/bootstrap-signer
/registry/serviceaccounts/kube-system/certificate-controller
/registry/serviceaccounts/kube-system/cilium
/registry/serviceaccounts/kube-system/cilium-operator
/registry/serviceaccounts/kube-system/clusterrole-aggregation-controller
/registry/serviceaccounts/kube-system/coredns
/registry/serviceaccounts/kube-system/cronjob-controller
/registry/serviceaccounts/kube-system/daemon-set-controller
/registry/serviceaccounts/kube-system/default
/registry/serviceaccounts/kube-system/deployment-controller
/registry/serviceaccounts/kube-system/disruption-controller
/registry/serviceaccounts/kube-system/endpoint-controller
/registry/serviceaccounts/kube-system/endpointslice-controller
/registry/serviceaccounts/kube-system/endpointslicemirroring-controller
/registry/serviceaccounts/kube-system/ephemeral-volume-controller
/registry/serviceaccounts/kube-system/expand-controller
/registry/serviceaccounts/kube-system/generic-garbage-collector
/registry/serviceaccounts/kube-system/horizontal-pod-autoscaler
/registry/serviceaccounts/kube-system/job-controller
/registry/serviceaccounts/kube-system/kube-proxy
/registry/serviceaccounts/kube-system/namespace-controller
/registry/serviceaccounts/kube-system/node-controller
/registry/serviceaccounts/kube-system/persistent-volume-binder
/registry/serviceaccounts/kube-system/pod-garbage-collector
/registry/serviceaccounts/kube-system/pv-protection-controller
/registry/serviceaccounts/kube-system/pvc-protection-controller
/registry/serviceaccounts/kube-system/replicaset-controller
/registry/serviceaccounts/kube-system/replication-controller
/registry/serviceaccounts/kube-system/resourcequota-controller
/registry/serviceaccounts/kube-system/root-ca-cert-publisher
/registry/serviceaccounts/kube-system/service-account-controller
/registry/serviceaccounts/kube-system/service-controller
/registry/serviceaccounts/kube-system/statefulset-controller
/registry/serviceaccounts/kube-system/token-cleaner
/registry/serviceaccounts/kube-system/ttl-after-finished-controller
/registry/serviceaccounts/kube-system/ttl-controller
/registry/services/endpoints/default/kubernetes
/registry/services/endpoints/kube-system/hubble-peer
/registry/services/endpoints/kube-system/kube-dns
/registry/services/specs/default/kubernetes
/registry/services/specs/kube-system/hubble-peer
/registry/services/specs/kube-system/kube-dns
```
