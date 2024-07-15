# Docker Redis 이미지 다운로드
# 공식문서: https://hub.docker.com/_/redis
docker pull redis
# 컨테이너 실행
# -d 백그라운드 실행
# -p 외부포트:내부포트
# --name 컨테이너 이름 지정
docker run -d --name docker_redis -p 6379:6379 redis
# 폴더 생성
mkdir -p /etc/redis

# 컨테이너 종료, 제거
docker stop docker_redis
docker rm docker_redis

# 도커 실행 
# -v 볼륨(저장소) 설정  외부경로:내부경로
docker run -d --name docker_redis -v /home/hadoop/redis/redis.conf:/etc/redis/redis.conf -p 6379:6379 redis redis-server /etc/redis/redis.conf


# 도커 redis-cli 접근
docker exec -it docker_redis redis-cli
# redis-cli 실행시 정상적인 경우 ping 입력시 pong 응답
# 예시
# 127.0.0.1:6379> ping
# PONG

# 데이터 저장 및 조회
set mykey "Hello, World!"
get mykey
# output: : Hello, World!

# 도커 로그 확인
docker logs docker_redis

# Redis 설정 확인
docker exec -it docker_redis cat /etc/redis/redis.conf

# 즉시 설정 적용
sudo sysctl vm.overcommit_memory=1

# 지속적인 적용
echo 'vm.overcommit_memory = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#######################################################
# 마스터노드 설정 변경
docker exec -it docker_redis /bin/bash
vi /etc/redis/redis.conf

######## conf 파일 내 정보 수정
bind 0.0.0.0
protected-mode no

# 비밀번호 설정
requirepass yourpassword

# 설정 변경 후 redis 재시작
exit  # 컨테이너 내부에서 나가기
docker restart docker_redis

# 슬레이브 설정파일 생성
echo "replicaof 192.168.0.204 6379" > /home/hadoop/redis/redis_slave.conf

# 마스터노드에 비밀번호 설정한 경우 아래 내용 추가
echo "masterauth yourpassword" >> /home/hadoop/redis/redis_slave.conf

# 기존 슬레이브가 있는 경우 삭제
docker stop redis_slave
docker rm redis_slave

# 슬레이브 컨테이너 실행
docker run -d --name redis_slave -v /home/hadoop/redis/redis_slave.conf:/etc/redis/redis.conf -p 6379:6379 redis redis-server /etc/redis/redis.conf

# 슬레이브 노드 redis-cli  확인
docker exec -it redis_slave redis-cli
info replication

# 마스터 노드에 데이터 쓰기
docker exec -it docker_redis redis-cli
set mykey "Hello, Redis!"
get mykey

# 슬레이브 노드에서 데이터 읽기
docker exec -it redis_slave redis-cli
get mykey

# 슬레이브 노드에서 데이터 쓰기
# READONLY 오류가 반환되어야 함
docker exec -it redis_slave redis-cli
set anotherkey "This should fail"

# 로그 확인하기
docker logs docker_redis
docker logs redis_slave

##############################################################################################################
: << "PYTHON"

import redis
r = redis.Redis(host="192.168.0.204", port=6379, password=123, db=0, decode_responses=True)
#from redis.commands.search.field import TextField, NumericField, TagField
#from redis.commands.search.indexDefinition import IndexDefinition, IndexType

### EXAMPLE 1
r.set('foo', 'bar')
# output: True

### EXAMPLE 2
r.get('foo')
# output: 'bar'

### EXAMPLE 3
res1 = r.hset(
    "bike:2",
    mapping={
        "model": "Deimos",
        "brand": "Ergonom",
        "type": "Enduro bikes",
        "price": 4972,
    },
)
print(res1)
# output: 4

### EXAMPLE 4
res2 = r.hget("bike:2", "model")
print(res2)
# output: Deimos

### EXAMPLE 5
res3 = r.hget("bike:2", "price")
print(res3)
# output: 4972

### EXAMPLE 6
res4 = r.hgetall("bike:2")
print(res4)
# output: {'model': 'Deimos', 'brand': 'Ergonom', 'type': 'Enduro bikes', 'price': '4972'}


# pooling 관련 코드는 RedisClient.py 파일 참조 
PYTHON
