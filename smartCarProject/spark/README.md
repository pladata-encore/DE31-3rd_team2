# Spark

**Description**

we want to set up spark cluster enviroment 
one spark-master and two spark-workernode,  

## How to Set up
### spark-master
```
cd spark_docker/spark_master
docker-compose up -d
```
### spark-worker
```
cd spark_docker/spark_worker
docker-compose up -d
```

It's easy to set up cluster but you need to configure `SPARK_MASTER_URL` in docker-compose.yaml file  
Each Directory has docker-compose.yaml file that make machine function as spark-master, spark-worker and spark-submit  
spark-master is core server in spark standalone cluster, So each docke file has `SPARK_MASTER_URL`

`SPARK_MASTER_URL` is "IP:port" in which spark-master server run  

focus docker-compose file in `spark_master` directory, in this current file setting, `SPARK_MATER_URL` port is 17077  
because docker container run 7077 port but it's forwarded host 17077 port  

and 18080 port is connected with spark-master webserver container 80 port

## HOW to use

spark-master and spark-worker is memebers of spark standalone cluster  
we suggest that one of strategy that use this cluster with spark-submit server  

spakr-submmit server is out of spark standalone cluster but has spark driver  
we submit job through this server to spark standalone cluster with python code

**spark-submit**  
```
cd spark_docker/spark_submit
docker-compose up -d
```
this command submit job through `spark_docker/workspace/example.py`  

if you want to alter python file path, modify `spark_docker/spark_submit/docker-compose.yaml` 

```
entrypoint: ["spark/bin/spark-submit", "--master", "spark://192.168.0.159:17077", "../workspace/example.py"]
```
- alter from `spark://192.168.0.159:17077` to spark://[your ip]:[your port]
- alter from `../workspace/example.py` to [your path]  (path point is directory that exist docker-compose.yaml file)

## Focus 
as a result, if you want to have a different port setting, you modify these port numbers

remember what is server url that run spark-master and modify port that you want to use

and spark-submit will help you use this cluster 

forget modify spark-submit command in docker-compose.yaml file 

# Story

we configure spark cluster setting  
each IPs are

```
spark-master : 192.168.0.159:17077 
spark-worker : [192.168.0.160, 192.168.0.161]

spakr-client(submit): 192.168.0.163
```

which Ips start "192..", this means that their network are private network.  

So in this setting, we only use cluseer in this private network


this is the reason that why does server-client exist in this setting
