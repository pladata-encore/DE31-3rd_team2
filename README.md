# 2024-07-02

## 1. 데이터 소스
> - SmartCar 무작위 생성 코드 다운
> - 실시간 로그 생성 : smartcar.log
> - 일단위 로그 생성 : driver.log

---

## 2. 플럼 설치
> - apache-flume 1.11.0 설치
> - .bashrc 경로 설정
> - flume/conf/flume-conf.propreties 플럼 환경 설정
> > 1. agent 생성
> > 2. agent 멀티 플로우 생성
> > 3. smartcar 플로우
> > > - source.type = spooldir
> > > - interceptor.type = regex_filter
> > > - channel.type = memory
> > > - sink.type = logger
> > 4. driver 플로우
> > > - source.type = exec
> > > - interceptor.type = regex_filter
> > > - channel.type = memory
> > > - sink.type = org.apache.flume.sink.kafka.KafkaSink
