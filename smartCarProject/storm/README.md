# Storm

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
