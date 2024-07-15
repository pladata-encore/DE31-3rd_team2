from pyspark.sql import SparkSession

# SparkSession 설정


spark = (
    SparkSession.builder.appName("MyApp")
    .master("spark://192.168.0.159:17077")
    .config("spark.hadoop.fs.defaultFS", "hdfs://192.168.0.160:8020")
    .config("spark.shuffle.service.enabled", "false")
    .config("spark.dynamicAllocation.enabled", "false")
    .getOrCreate()
)
# Spark 작업 수행
path = "hdfs://192.168.0.160:8020/smartCar/dataLake/carStatus/batchData/SmartCarStatusInfo_20240712.txt"
df = spark.read.text(path)
df.show()

# SparkSession 종료
spark.stop()
