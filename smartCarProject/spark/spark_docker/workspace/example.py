from pyspark import SparkConf, SparkContext

# 스파크 설정 및 컨텍스트 생성
conf = SparkConf().setAppName("SimpleApp")
sc = SparkContext(conf=conf)

# 데이터 준비
data = [1, 2, 3, 4, 5]

# RDD 생성
distData = sc.parallelize(data)

# RDD 연산
result = distData.reduce(lambda a, b: a + b)

# 결과 출력
print("Sum of elements:", result)

# 스파크 컨텍스트 종료
sc.stop()
