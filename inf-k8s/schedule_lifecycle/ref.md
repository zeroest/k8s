
# Schedule Lifecycle

[조대협님](https://bcho.tistory.com/1291)

## Resource Quota vs Limit Range
Resource Quota가 네임 스페이스 전체의 리소스양을 정의한다면, Limit Range는 컨테이너 개별 자원의 사용 가능 범위를 지정한다.

## Overcommitted 상태 
이  request와 limit의 개념이 있기 때문에 생기는 문제인데, request 된 양에 따라서 컨테이너를 만들었다고 하더라도, 컨테이너가 운영이되다가 자원이 모자르면 limit 에 정의된 양까지 계속해서 리소스를 요청하게 된다.
컨테이너의 총 Limit의 양이 실제 시스템이 가용한 resource의 양보다 많을 수 있는 경우가 발생한다. 이를 overcommitted 상태라고 한다.
Overcommitted 상태가 발생하면, CPU의 경우에는 실제 사용량을 requested 에 정의된 상태까지 낮춘다. 예를 들어 limit이 500, request가 100인 경우, 현재 500으로 가동되고 있는 컨테이너의 CPU할당량을 100으로 낮춘다. 그래도 Overcommitted 상태가 해결되지 않는 경우, 우선 순위에 따라서 운영중인 컨테이너를 강제 종료 시킨다.  
메모리의 경우에는 할당되어 사용중인 메모리의 크기를 줄일 수 는 없기 때문에, 우선 순위에 따라서 운영 중인 컨테이너를 강제 종료 시킨다.  Deployment,RS/RC에 의해 관리되고 있는 컨테이너는 다시 리스타트가 되고 초기 requested 상태의 만큼만 자원 (메모리/CPU)를 요청해서 사용하기 때문에, overcommitted  상태가 해제된다. 

## Best practice
구글 문서에 따르면 데이타 베이스등 아주 무거운 애플리케이션이 아니면, 일반적인 경우에는 CPU request를 100m 이하로 사용하기를 권장한다. 
또한 세밀하게 클러스터를 운영하기 어려운 경우에는 request와 limit의 사이즈를 같게 하는 것을 권장한다. limit이 request보다 클 경우 overcommitted 상태가 발생할 수 있는데, 이때 CPU가 throttle down 되면, 실제 필요한 CPU양 보다 작은 CPU양으로 줄어들기 때문에 성능저하가 발생할 수 있다.  

