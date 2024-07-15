#postgreSQL Setting
################
192.168.0.156
192.168.0.157
################

# key
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# repository 
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

sudo apt-get update

# install 
sudo apt-get install postgresql-14

sudo systemctl start postgresql
sudo systemctl enable postgresql


# 설정
sudo vim /etc/postgresql/14/main/postgresql.conf
sudo vim /etc/postgresql/14/main/pg_hba.conf

## postgresql.conf설정파일 수정
listen_addresses = '*'
## pg_hba.conf설정파일 수정
host    all             all             0.0.0.0/0               scram-sha-256


# 방화벽 설정
sudo ufw enable
sudo ufw allow 5432/tcp
# ssh port 연결
sudo ufw allow 22/tcp
# postgresql 연결
sudo systemctl restart postgresql

##########
# postgreSQL 사용자 : root로 전환
sudo -i -u postgres

# 데이터베이스 생성
createdb datamart

# 사용자 생성
psql -c "CREATE USER smartcar WITH PASSWORD '123';"

# 사용자 확인
\du

# 권한 부여
psql -c "GRANT ALL PRIVILEGES ON DATABASE datamart TO smartcar;"

# 접속
psql -h 192.168.0.157 -U smartcar -d datamart
psql -h 192.168.0.156 -U smartcar -d datamart_serve
## 다른 서버에서 접속하여 수정, 삽입 가능

# Client 서버
## postgresql 클라이어트 패키지 설치
sudo apt-get update
sudo apt-get install postgresql-client-14
## 서버 패키지 설치
sudo apt-get install postgresql-14

psql --version
# 출력 psql (PostgreSQL) 14.0

# 다른 애플리케이션에서 postgresql DB 접속
import psycopg2

# Connect to PostgreSQL
conn = psycopg2.connect(
    host="192.168.0.157",
    database="datamart",
    user="smartcar",
    password="123"
)

conn2 = psycopg2.connect(
    host="192.168.0.156",
    database="datamart_serve",
    user="smartcar",
    password="123"
)

############################

#Hive metaDB로 postgreSQL을 설정

1. postgreSQL jdbc라이브러리 copy -> hive/lib/

[hadoop@olmaster:~/hive-0.9.0/lib]$ pwd
/home/hadoop/hive-0.9.0/lib
[hadoop@olmaster:~/hive-0.9.0/lib]$
[hadoop@olmaster:~/hive-0.9.0/lib]$ cp /mnt/hgfs/common/postgresql-9.2-1001.jdbc4.jar  .

2. root로 접속, DB생성 (hive가 사용할 metastroeDB)
sudo -u postgres psql
CREATE DATABASE metastore;
\c metastore;
\pset tuples_only_on
\o /tmp/grant-prives
SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON "' || schemaname || '" TO hiveuser;'
FROM pg_tables
WHERE tableowner = CURRENT_USER and shcemaname = 'public';
\o
\pset tuples_only off
\i /tmp/grant-prives


3. 템플릿 생성
hive/conf
# hive-site.xml 수정
$ cp hive-default.xml.template hive-site.xml
$ vi hive-site.xml

xml코드 복사
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:postgresql://localhost:5432/metastoredb</value>
    <description>JDBC connect string for a JDBC metastore</description>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.postgresql.Driver</value>
    <description>Driver class name for a JDBC metastore</description>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hiveuser</value>
    <description>username to use against metastore database</description>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>yourpassword</value>
    <description>password to use against metastore database</description>
  </property>

  <property>
    <name>datanucleus.autoCreateSchema</name>
    <value>true</value>
    <description>create necessary schema automatically</description>
  </property>

  <property>
    <name>hive.metastore.schema.verification</name>
    <value>false</value>
    <description>disable metastore schema verification</description>
  </property>

  <property>
    <name>hive.metastore.uris</name>
    <value>thrift://localhost:9083</value>
    <description>Thrift URI for the remote metastore. Used by metastore client to connect to remote metastore.</description>
  </property>
</configuration>

# hiveuser에게 DB권한 부여
postgres# ALTER USER hiveuser CREATEDB;
# hive가 사용할 postgre의 DB를 생성 
CREATE DATABASE hivedb;
# hiveuser가 사용할 metastoreDB이름 -> hive-site.xml에 입력
(base) hadoop@datanode6:~/hive/conf$ vi hive-site.xml
# hive-site.xml 수정
javax.jdo.option.ConnectionURL 
jdbc:postgresql://192.168.0.156:5432/hivedb  ## 수정
JDBC connect string for a JDBC metastore


# 스키마 초기화 및 생성
(base) hadoop@datanode6:~/hive/conf$ schematool -initSchema -dbType postgres
# 생성된 스키마 확인
\dt

#재시작

#hive beeline에서 hive postgresql Connect
!connect jdbc:postgresql://192.168.0.156:5432/hivedb hiveuser 123

#heidi에서 postgresql 데이터베이스 접속
host : 192.168.0.156 or 192.168.0.157 / pw : 123 hiveuser, hivedb  / port : 5432

#####################
# Spark에서 postgresql database접근


# postgresql - db조회, metastore table조회
SELECT datname FROM pg_database;

SELECT * FROM pg_catalog.pg_tables
where 1=1
and schemaname = 'public';

# hadoop 데이터 저장할 hive table 생성
CREATE TABLE SmartCar_Status_Info (
datetime date,
column1 varchar(40),
column2 varchar(40),
column3 varchar(40),
column4 varchar(40),
column5 varchar(40),
column6 varchar(40),
column7 varchar(40),
column8 varchar(40),
column9 varchar(40),
column10 varchar(40),
column11 varchar(40),
column12 varchar(40)
);

# vs-code : pyspark실행
pyspark --driver-class-path ./hive/lib/postgresql-42.2.19.jar --jars ./hive/lib/postgresql-42.2.19.jar

#  pyspark에서 hive support session만들기
- pyspark jupyternotebook에서 실행
# postgre jar파일 spark에도 copy 후 저장

# pyspark에서 postgre 의 hive db로 접속하는 코드
import os
jardrv = "./hive/lib/postgresql-42.2.19.jar"


from pyspark.sql import SparkSession
# spark = SparkSession.builder.config('spark.driver.extraClassPath', jardrv).getOrCreate()

conf = pyspark.SparkConf().setAppName("smartCar").\
        setMaster("spark://client:7077").\
        set("spark.executor.instances", "4") .\
        set("spark.executor.cores", "2").\
        set("spark.cores.max", "8").\
        set("spark.driver.cores", "2") 
spark = SparkSession.builder.config(conf=conf).getOrCreate()

url = 'jdbc:postgresql://192.168.0.157/hivedb'
properties = {'user': 'hiveuser', 'password': '123'}
df = spark.read.jdbc(url=url, table='SmartCar_Status_Info', properties=properties)

df.printSchema()

# 출력 결과
root
 |-- datetime: date (nullable = true)
 |-- column1: string (nullable = true)
 |-- column2: string (nullable = true)
 |-- column3: string (nullable = true)
 |-- column4: string (nullable = true)
 |-- column5: string (nullable = true)
 |-- column6: string (nullable = true)
 |-- column7: string (nullable = true)
 |-- column8: string (nullable = true)
 |-- column9: string (nullable = true)
 |-- column10: string (nullable = true)
 |-- column11: string (nullable = true)
 |-- column12: string (nullable = true)




