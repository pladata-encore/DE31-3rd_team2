# NIFI 환경 구축
- 클러스터 3대로 구축 예정
- NIFI VERSION=1.27.0
- JAVA VERSION=17
```shell
sh nifi_setup.sh [매개변수]
```
- 쉘스크립트 매개변수: [1, 2, 3]
- 클러스터 노드마다 매개변수 하나씩 설정
---

# NIFI TOOLKIT 설치
-HTTPS 클러스터 환경을 구축할려면 NIFI TOOLKIT 필요
```shell
sh nitk_setup.sh [노드1], [노드2], [노드3]
```
- jks 키 생성 후, 각 노드의 nifi/conf/ 폴더로 전송
- nifi.properties의 내용 수정
