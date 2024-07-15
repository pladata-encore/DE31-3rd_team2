# hive 설치
wget https://dlcdn.apache.org/hive/hive-4.0.0/apache-hive-4.0.0-bin.tar.gz
tar xvfz apache-hive-4.0.0-bin.tar.gz

# hive-site.xml, hive-env.sh경로
/home/hadoop/hive/conf

vim ~/.bashrc
# bashrc에 경로 입력
export HIVE_HOME=/home/hadoop/hive
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:/home/hadoop/hadoop/lib/native:$HIVE_HOME/bin


sudo apt install openjdk-11-jdk -y 

hive/conf/hive-env.sh 
# 아래 내용 추가 
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
HADOOP_HOME=/home/hadoop/hadoop

###################
# 공유서버에 hive scp
- [ ]  key-gen
- [ ]  key copy (개발서버 → 공용서버)
- [ ]  개발 서버에 설치되어있는 hive 폴더 → datanode, namenode, secondarynode로 scp
- [ ]  bashrc 에 hive경로입력

# hive실행 (cmd창 3개에서)
hive --service metastore
hive --service hiveserver2
hive
beeline> !connect jdbc:hive2://namenode:10000/default; hive password org.apache.hive.jdbc.HiveDriver

### Hive Server Setting ###
# namenode : 192.168.0.160
# port : 10000
# user: hive / pw : password


#####################
# Hive, Hue 설정

# Hue 설정파일 수정
sudo vim /opt/hadoop-docker/hue/hue.ini

#수정
name=hue
user=hueuser
password=123
host=192.168.0.157
port=5432

[hadoop]
[[hdfs_clusters]]
[[[default]]]
fs_defaultfs=hdfs://namenode:8020


[[yarn_clusters]]
[[[default]]]
resourcemanager_host=secondnode

[beeswax]
hive_server_host=192.168.0.160
hive_server_port=10000

# Hive 설정파일 수정
# hive.server2.authenticattion
# auth=noSasl -> NONE 으로 변경

# Hue 재부팅
docker-compose down
docker-compose up -d

# Hive - Hue test
# 쿼리실행

create external table if not exists SmartCar_Status_Info1 (
reg_date string,
car_number string,
tire_fl string,
tire_fr string,
tire_bl string,
tire_br string,
light_fl string,
light_fr string,
light_bl string,
light_br string,
engine string,
break string,
battery string
)
row format delimited fields terminated by ','
location '/smartCar/dataLake/carStatus/batchData/';

select * from smartcar_status_info1 limit 3;

select * from SmartCar_Status_Info1 limit 5;  select car_number, avg(battery) as battery_avg from SmartCar_Status_Info1 where battery < 60 group by car_number;

