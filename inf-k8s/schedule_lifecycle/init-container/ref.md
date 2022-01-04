
# Init Container

[doc](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

- 포드 컨테이너 실행 전에 초기화 역할을 하는 컨테이너
- 완전히 초기화가 진행된 다음에야 주 컨테이너를 실행
- Init 컨테이너가 실패하면, 성공할때까지 포드를 반복해서 재시작
- restartPolicy에 Never를 하면 재시작하지 않음

포드 시작 -> init 컨테이너 -(성공시)-> 주 컨테이너

   ^-----(실패시)---|



