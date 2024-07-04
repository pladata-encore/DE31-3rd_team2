#!/bin/bash

# 1일 단위 자동차 로그 생성
java -cp ./bigdata.smartcar.loggen-1.0.jar com.wikibook.bigdata.smartcar.loggen.CarLogMain 20240704 100 &
# 실시간 운전자 로그 생성
java -cp ./bigdata.smartcar.loggen-1.0.jar com.wikibook.bigdata.smartcar.loggen.DriverLogMain 20240704 100 &
