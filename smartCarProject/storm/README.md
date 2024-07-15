# Storm

## How to set

**Storm download** 
```
wget https://dlcdn.apache.org/storm/apache-storm-2.6.2/apache-storm-2.6.2.tar.gz
tar -zxvf apache-storm-2.6.2.tar.gz 
mv apache-storm-2.6.2.tar.gz storm
```

**Nimbus & supervisor setting***
```
# storm/conf/storm.yaml file

storm.zookeeper.servers:
    - "broker2"
    - "broker3"
    - "broker4"

nimbus.seeds: ["broker1"]
```

## How to use 
```
mvn clean package

```

## Environment
- openjdk : t8
- kafk:3.4
- redis: 6.6.1

## Detail
### Kafka-Spout
- Topic : SmartCar-Topic
### Redis-End Bolt
- key: date(Ymd)
- value: 과속 차량 번호

## setting

```
192.168.0.201 master
192.168.0.202 worker1
192.168.0.203 worker2
192.168.0.204 worker3
```

- 웹서버 : 192.168.0.201:8080
