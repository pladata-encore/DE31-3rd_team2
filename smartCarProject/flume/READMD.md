# 1. 데이터 소스
[깃허브: 데이터 소스](https://github.com/wikibook/bigdata2nd)
- SmartCar 무작위 데이터 생성 파일: bigdata.smartcar.loggen-1.0.jar
- 로컬 환경 구축
```shell
mkdir -p ~/[본인의 경로]/driver-realtime-log
mkdir -p ~/[본인의 경로]/SmartCar
# flume spooldir 디렉토리
mkdir -p ~/[본인의 경로]/car-batch-log
mv bigdata.smartcar.loggen-1.0.jar ~/working/
```
## SmartCar Log 생성 코드
- data_start.sh
```shell
# 1일 단위 자동차 로그 생성
java -cp ~/[본인의 경로]/bigdata.smartcar.loggen-1.0.jar com.wikibook.bigdata.smartcar.loggen.CarLogMain $1 100 &
# 실시간 운전자 로그 생성
java -cp ~/[본인의 경로]/bigdata.smartcar.loggen-1.0.jar com.wikibook.bigdata.smartcar.loggen.DriverLogMain $1 100 &
```
- 1일 단위 자동차 로그 조회
```shell
cat ~/[본인의 경로]/SmartCar/SmartCarStatusInfo_20240101.txt
```
- 실시간 운전자 로그 조회
```shell
tail -F ~/[본인의 경로]/driver-realtime-log/SmartCarDriverInfo.log
```
- spooldir 적재
```shell
mv ~/[본인의 경로]/SmartCar/SmartCarStatusInfo_$1.txt ~/[본인의 경로]/car-batch-log/
```
---

# 2. 플럼
- apache-flume 1.11.0 설치
```shell
wget https://dlcdn.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz
```
- 플럼 경로 설정
![플럼 설정 이미지](./images/)
- 플럼 환경 설정
![플럼 설정 이미지](./images/)
## SmartCar_Agent 간단 설명
> - Agent: SmartCar_Agent
> - Source: SmartCarInfo_SpoolSource, DriverCarInfo_TailSource
> - Channel: SmartCarInfo_Channel, DriverCarInfo_Channel
> - Sink: SmartCarInfo_HdfsSink, DriverCarInfo_KafkaSink
> - SpoolDir source: 주로 로그 파일 등을 실시간으로 읽어들여 데이터를 전송하는 용도로 사용
> - Exec source: 외부 명령(command)을 실행하여 그 결과를 데이터 스트림으로 수집
> - Memory channel: 메모리에 적재하여 높은 성능을 보여주지만 위험성 높음
> - File channel: file에 적재하여 낮은 성능을 보여주지만 위험성 낮음
> - Hdfs sink: 수집된 데이터를 하둡 파일 시스템에 로그 파일로 전송
> - Kafka sink: 수집한 데이터를 Apache Kafka로 전송
> - Interceptor: 수집된 데이터를 channel에 보내기 전에 전처리하여 유효한 데이터만 적재
## Flume 실행
- flume_start.sh
```shell
flume-ng agent --conf conf --conf-file flume.conf --name SmartCar_Agent -Xmx512m -Dflume.root.logger=INFO,FILE
```
- kafka consumer에서 실시간 데이터 확인 가능
- 하둡 디렉토리에서 배치성 데이터 확인 가능
---

# 3. 오류
### 2024.07.02
1. kafka@broker1 경로 문제
> - .bashrc 수정하여도 $PATH에서 수정된 코드를 인식하지 못하여 문제 발생
> - 원인을 알 수 없어서 다른 방법 탐색
> - 실제 디렉토리를 PATH에 맞게 수정
> - 해결
2. FLUME - KAFKA 연동 실패
> - 예제는 FLUME 1.9.0 버전을 이용하여 명령어 에러 발생
> - apache flume 1.11.0 공식문서를 확인하여 버전에 맞는 명령어 수정
> - 해결
### 2024.07.03
1. FLUME - HADOOP 연동 실패
> - 사용자 정의 인터셉어를 인식하지 못하는 문제 발생
> - FLUME, 자바에 관해 미숙하여 적용 실패
> - 사용자 정의 인터셉터 제거로 해결 후, 하둡에 데이터가 적재되지 않는 형상 발견
> - 해결 실패
### 2024.07.04
1. 하둡 계정 권한 문제
> - 리눅스 터미널에서 hdfs로 접속하여 하둡 연결 확인
> - 연결 성공을 확인했지만 계정 권한 문제에 부딪치며 하둡 조회만 가능하다는 것을 문제 확인
> - 하둡 권한을 수정할 수 있는 권한이 없어서 권한이 있는 하둡 계정으로 옮기니 하둡에 로그 데이터 정상 적재 확인
> - Flume의 문제점: hdfs 접속 성공 메세지만 뜨고 권한 오류 메세지는 발생하지 않음!
> - 해결

