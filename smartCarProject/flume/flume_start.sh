#!/bin/bash

# spooldir 적재
mv ~/workspace/DE31-3rd_team4/smartCarProject/flume/SmartCar/SmartCarStatusInfo_$1.txt ~/workspace/DE31-3rd_team4/smartCarProject/flume/car-batch-log/

# flume 실행
flume-ng agent --conf conf --conf-file /opt/flume/conf/flume.conf --name SmartCar_Agent -Xmx512m -Dflume.root.logger=INFO,FILE
