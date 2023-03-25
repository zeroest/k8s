
# 레이블 배치 전략
[9 Best Practices and Examples for Working with Kubernetes Labels](https://www.replex.io/blog/9-best-practices-and-examples-for-working-with-kubernetes-labels?fbclid=IwAR0S2tT3iw8FIkVYWwyjL8OW6IWi_gXfk0fDkAk57o6re1rRnoSRRzFVXiM)

쿠버네티스 레이블(Labels)에 대한 9가지 모범 사례

쿠버네티스 labels를 이용하면 Devops팀에서 쿠버네티스 객체(kubernets objects)를 식별하고 선택하고 운영할 수 있습니다.

쿠버네티스에는 멋진 내장기능이 많습니다. 레이블 또한 그 중 하나입니다. 쿠버네티스 레이블을 통해 Devops팀은 쿠버네티스 객체를 식별할 수 있고, 그룹으로 구성할 수 있습니다.  

쿠버네티스 레이블에 대한 좋은 사용 사례(use-case) 중 하나는, 파드에 배치된 어플리케이션을 기반으로 그룹핑하는 것 입니다. 또한 환경이나 고객, 팀/소유자, 릴리즈 버전에 따라서 그룹화하는 다양한 레이블 규칙을 개발할 수 있습니다.  

하지만 이것은 시작에 불과합니다. 쿠버네티스 레이블에는 더욱 다양한 기능이 포함되어 있습니다. 예를 들어, 쿠버네티스 레이블을 이용하여 수많은 리소스(resources)에 대해 필터링하여 kubectl을 통한 대량 작업을 수행할 수 있습니다. 또한 쿠버네티스 배포에는 레이블을 통해 쿠버네티스 관리하는 파드를 식별합니다. 이와 유사하게, 쿠버네티스 서비스와 레플리케이션(replication) 컨트롤러는 레이블을 이용하여 파드의 그룹(set)를 참조합니다. 권장되는 쿠버네티스 레이블들은 쿠버네티스 툴들 사이의 쿼리(querying)와 상호운용성(interoperability)를 지원합니다.  

아래에서 쿠버네티스 레이블에 대한 몇 가지 모범사례를 살펴봅니다.

## 1. 구문에 대해 주의하라. (Beware of the Syntax)

당신이 쿠버네티스 레이블을 사용할때 올바를 구문(syntax)을 사용하는지 확인해야 합니다. 아래에는 레이블 구문에 대한 개요를 보여줍니다. 당신은 label key(label prefix + label name)와 label value, 총 3가지에 대해 고려해야 합니다.

- Label Key
  - Label Prefix
    - Label Prefix는 선택사항이다.
    - Label Prefix는 253자 이하이어야 한다.
    - Label Prefix는 DNS subdomain이어야 한다.
    - Label Prefix는 "."로 구분된 일련의 DNS subdomain일수도 있다.
    - Label Prefix는 "/"로 끝나야 한다.
  - Label Name
    - Label Name은 필수사항이다.
    - Label Name은 최대 63자이다.
    - Label Name은 영문, 숫자로 구성되어야 한다.
    - Label Name은 "-", "_", "."을 포함할 수 있다.
    - Label Name의 시작과 끝은 영문 또는 숫자이어야 한다.
- Label Value
  - Lable Value는 최대 63자이다.
  - Label Value는 영문, 숫자로 구성되어야 한다.
  - Label Value는 "-", "_", "."을 포함할 수 있다.
  - Label Value의 시작과 끝은 영문 또는 숫자이어야 한다.

[공식문서](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)를 통해 보다 상세한 내용을 참조할 수 있습니다.

## 2. 레이블을 꼭 적용해라. (Label, Label, Label)

쿠버네티스 레이블에 대한 첫번째 규칙은 언제나 실제로 적용(do)하는 것입니다.  

당신이 새로운 리소스를 생성할때, 그 다음 순서는 자연스럽게 쿠버네티스 레이블을 새롭게 생성하거나 추가(attach)하는 것이 되어야 합니다. 이미 운영중인 리소스에 대해서 레이블이 정상적으로 적용되었는지에 대한 정기적인 확인을 하는 것도 좋은 방법입니다.  

물론 이와 같은 방법은 업무 속도를 저하시킬 수 있습니다. 하지만, 모든 것에 대해 레이블을 적용하는 것은 추후 이득을 볼 수 있습니다.  

리소스에 대해 레이블을 적용하는 것은 쿠버네티스 운영환경에서 고통을 덜어줄 수 있습니다. 또한 레이블을 적용하면 쿠버네티스 개체들에 대한 대량 작업을 더 쉽게 만들어 줍니다. 이에 대한 예시로, 레이블 셀렉터(label selector)를 사용하여 쿠버네티스 배포 및 서비스 가동시 레이블을 기반으로 파드들을 선택할 수 있습니다.  

kubectl을 이용한 몇가지 레이블 명령어는 다음과 같습니다.

우선 레이블 적용을 위한 pod는 다음과 같습니다.

```yaml
# label-example.yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    environment: staging
    team: kube-team
spec:
  containers:
    - name: my-container
      image: "k8s.gcr.io/my-app:v0.1"
      resources:
        limits:
          cpu: 1
```

위의 yaml파일을 통해 생성된 파드의 레이블을 확인하기 위해서는 아래의 명령어를 사용합니다.
```shell
kubectl get pod my-pod --show-labels
```

파드에 새로운 레이블을 추가하려면 아래의 명령어를 사용합니다.
```shell
kubectl label pod my-pod versionID=ver0.9
```

파드의 레이블을 삭제하려면 다음의 명령어를 사용합니다. 삭제시에는 레이블 키(label key)를 통해 삭제합니다.
```shell
kubectl label pod my-pod versionID-
```

파드의 기존 레이블을 변경(업데이트)하려면 다음의 명령어를 사용합니다.
```shell
kubectl label --overwrite pods my-pod team=ops
```


## 3. 레이블 규정(conventions)에 대한 전사적인 규약(consensus)을 만들어라. (Create company-wide consensus on labeling conventions)

레이블(labels)은 쿠버네이스 내부적으로도, Devops팀에게도 의미가 깊고 관련이 있기 때문에, 레이블 규칙에 대해서 합의하여 도출하는 것은 매우 중요합니다. 당신의 Devops팀과 함께 모여 쿠버네티스 리소스를 위한 표준 레이블 규칙에 대해 논의하세요. 또한 그 규칙이 팀과 조직을 넘어 전파될 수 있도록 해야 합니다.

## 4. 필수적인 레이블 리스트를 만들어라. (Create a list of required labels)

물론 어떤 사람들은 시대에 적응하지 못합니다.(Some people just do not get with the times.) 그들을 위해서 쿠버네티스 파드가 생성될 때 정의해야 하는 레이블의 리스트를 제안할 수 있습니다. 하나의 개체당 3-4개씩, 작게 시작합시다.

모든 쿠버네티스 개체에 대해 어플리케이션ID, 버전, 소유자, 환경(stage), 릴리즈버전을 필요로하는 Zalando의 예시를 이용하여 시작하는 것도 좋습니다.

https://kubernetes-on-aws.readthedocs.io/en/latest/user-guide/labels.html

당신은 파드 템플릿을 활용하여 필요한 레이블을 추가할 수 있습니다. 파드 템플릿은 쿠버네티스 컨트롤러에서 파드를 생성하기 위한 manifest파일입니다.

아래의 파드 템플릿은 application ID, version, stage, release, owner를 포함합니다.

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: my-pod
 labels:
   application-ID: my-app
   version: version-nr
   stage: dev
   release: release-nr
   owner: team-kube

```

## 5. 더 광범위한 레이블 리스트를 만들어라. (Create a more extensive list of Kubernetes labels)

필수적인 레이블 리스트를 만들고 나서 멈추면 안됩니다. 당신이 쿠버네티스를 관리하고 운용하는 동안 지속적으로 발전시켜야 합니다. 쿠버네티스 개체에 더 많은 활용성(operability)과 컨텍스트(context)를 제공할 수 있는 더 광범위한 레이블을 지속해서 만들어야 합니다. 다음 내용은 쿠버네티스 예제에 포함되어 제공하는 모든 레이블 예시입니다. 이 중에서 선택하여 사용하는 것도 좋은 방법입니다.

| Label Example Key | Description | Label Example Value |
| --- | --- | --- |
| Application-ID/Application-name | The name of the application or its ID | my-awesome-app/app-nr-2345 |
| Version-nr | The version number | ver-0.9 |
| Owner | The team or individual the object belongs to | Team-kube/josh |
| Stage/Phase | The stage or phase | Dev, staging, QA, Canary, Production |
| Release-nr | The release number | release-nr-2.0.1 |
| Tier | Which tier the app belongs to | front-end/back-end |
| Customer-facing | Is the resource part of an app that is costomer facing? | Yes/No |
| App-role | What roles does the app have | Cache/Web/Database/Auth |
| Project-ID | The associated project ID | my-project-276 |
| Customer-ID | The customer ID for the resource | customer-id-29 |

## 6. 쿠버네티스에서 추천하는 레이블을 사용해라. (Use recommended Kubernetes labels)

쿠버네티스에서는 추천되는 레이블을 제공합니다. app.kubernetes.io 와 같은 레이블들은 당신이 생성하고 공유 접두사가 있는 모든 개체에 대해서 권장됩니다. 접두사는 권장되는 레이블이 사용자가 생성한 레이블과 혼동되지 않도록 합니다.

권장되는 레이블은 다음과 같습니다.

- app.kubernetes.io/name
- app.kubernetes.io/instance
- app.kubernetes.io/version
- app.kubernetes.io/component
- app.kubernetes.io/part-of
- app.kubernetes.io/managed-by

아래에는 권장되는 레이블을 활용한 예시 파드 템플릿 입니다.

```yaml
apiVersion: v1
kind: Pod
metadata:
 labels:
    app.kubernetes.io/name: my-pod
    app.kubernetes.io/instance: Auth-1a
    app.kubernetes.io/version: “2.0.1”
    app.kubernetes.io/component: Auth
    app.kubernetes.io/part-of: my-app
    app.kubernetes.io/managed-by: helm
```

## 7. 미리 만들어지는 쿠버네티스 레이블을 확인해라. (Monitor pre-populated Kubernetes labels)

쿠버네티스는 노드에만 또는 노드와 볼륨에 모두 적용된, 미리 채워진 레이블 리스트를 제공합니다. 미리 채워진 레이블은 여러 가지 방법으로 사용할 수 있습니다. 예를 들어, 특정 인스턴스 유형으로 워크로드를 대상으로 하거나 다양한 클라우드 제공자 영역을 넘어 레플리케이션 컨트롤러 또는 서비스에 파드를 분산시킬 때 사용할 수 있습니다.

노드 관해 제공되는 레이블은 다음과 같습니다.

- beta.kubernetes.io/arch
- beta.kubernetes.io/os
  - Value는 Linux와 같은 OS 타입으로 채워집니다.
- beta.kubernetes.io/hostname
  - Value는 hostname으로 채워집니다.
- beta.kubernetes.io/instance-type
  - Value는 t2.medium과 같이 클라우드 제공자에 따른 instance type이 채워집니다.

노드와 볼륨에 모두 제공되는 레이블은 다음과 같습니다.

- failure-domain.beta.kubernetes.io/region
  - Value는 eu-west-1과 같이 클라우드 제공자에 따른 region이 채워집니다.
- failure-domain.beta.kubernetes.io/zone
  - Value는 eb-west-1b와 같이 클라우드 제공자에 따른 zone이 채워집니다.

## 8. Kops에서 클라우드 레이블과 노드 레이블을 규정해라. (Specify Cloudlabels and NodeLabels in Kops)

Kops는 고가용성(highly available) 쿠버네티스 클러스터를 배포하고 관리하기 위한 도구입니다. Devops팀은 Kops를 이용하여 CloudLables와 NodeLabels 두가지에 대해 지정할 수 있습니다. 두가지 타입의 라벨 모두 instanceGroup 레벨에서 지정됩니다. Kops의 instanceGroup은 AWS의 autoscailing group과 유사합니다.

InstanceGroup에 CloudLabels를 적용하면, 그것들은 instanceGroup의 일부인 모든 instance에 적용되며 AWS console에 AWS tag로 표시됩니다. 이를 이용하여 비용 할당 및 차지백(chargeback)을 수행할 수 있습니다.

비용 할당에 대해 권장되는 CloudLabels는 어플리케이션 이름(application name), 비용 센터(cost center), 스택(stack: test, prod), 소유자(owner, team), 고객(customer)와 프로젝트(project)가 있습니다. NodeLabels는 쿠버네티스 레이블(Labels)과 동일하며 쿠버네티스 노드에 적용됩니다.

## 9. 레이블과 어노테이션에 대한 구분을 지어라. (Differentiate between Kubernetes labels vs annotations)

쿠버네티스 레이블과 어노테이션은 모두 쿠버네티스 개체에 대해 메타데이터를 추가하는 방법입니다. 그러나 둘의 유사점은 그것이 전부입니다. 쿠버네티스 레이블은 쿠버네티스 개체를 식별하고 선택하고 운영할 수 있도록 합니다. 반면에 어노테이션은 식별되지 않는 메타데이터이며 앞의 기능을 수행하지 않습니다.

어노테이션은 쿠버네티스 개체에 비식별 메타데이터를 추가합니다. 예시로, 디버깅 목적으로 해당 개체에 대해 책임을 가지고 있는 사람의 전화번호나 도구(tool) 정보를 담을 수 있습니다. 간단히 말해서, 어노테이션은 Devops팀(또는 다른 사용자)에게 유용하고 의미있는 컨텍스트(context)를 제공할 수 있는 모든 정보를 담을 수 있습니다.

## 결론 (Conclusion)

쿠버네티스 레이블은 쿠버네티스 객체 및 리소스를 식별하고 구성하는 좋은 방법입니다. 쿠버네티스 팀 리더와 IT매니저는 쿠버네티스 레이블 계획을 구성하고 구현하는 데 가장 적합합니다. 팀 전체에서 레이블 규칙을 따르게 함으로써 쿠버네티스 환경을 보다 잘 길들이고 무분별한 확산이 없도록 막을 수 있습니다. 레이블을 사용하면 쿠버네티스 개체에 대해 대량으로 작업하는 것이 보다 쉬워지므로, 레이블 지정 규칙을 준수하면 장기적으로 팀의 효율성, 생산성 또한 증가할 수 있습니다.
