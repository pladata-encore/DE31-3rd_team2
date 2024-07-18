from hdfs import InsecureClient


class HadoopClient:
    def __init__(self, hdfs_url, user):
        self.client = InsecureClient(hdfs_url, user=user)

    def write_data(self, hdfs_path, data):
        with self.client.write(hdfs_path, encoding="utf-8") as writer:
            writer.write(data)
        print(f"Data written to {hdfs_path}")

    def read_data(self, hdfs_path):
        with self.client.read(hdfs_path, encoding="utf-8") as reader:
            data = reader.read()
        print(f"Data read from {hdfs_path}")
        return data

    def list_files(self, hdfs_path):
        files = self.client.list(hdfs_path)
        print(f"Files in {hdfs_path}: {files}")
        return files

    # def delete_files(self, hdfs_path):
    #     try:
    #         delete_files = self.client.delete(hdfs_path, recursive=True)
    #         print(f"{hdfs_path}에서 {len(delete_files)}개의 파일을 삭제하였습니다.")
    #         return True

    #     except Exception as e:
    #         print(f"{hdfs_path}의 파일 삭제 중 오류 발생: {str(e)}")
    #         return False


if __name__ == "__main__":
    hdfs_url = "http://namenode:50070"
    user = "hadoop"
    hdfs_path = "/smartCar/dataLake/carStatus"

    hadoop_client = HadoopClient(hdfs_url, user)

    # HDFS에 데이터 쓰기
    hadoop_client.write_data(hdfs_path + "/test.txt", "안녕하세요, HDFS!")

    # HDFS에서 데이터 읽기
    data = hadoop_client.read_data(hdfs_path + "/test.txt")
    print("읽은 데이터:", data)

    # HDFS 디렉토리에 있는 파일 목록 보기
    files = hadoop_client.list_files(hdfs_path)
    print("디렉토리의 파일 목록:", files)

    # # HDFS 디렉토리의 파일 삭제
    # success = hadoop_client.delete_files(hdfs_path)
    # if success:
    #     print(f"{hdfs_path}의 파일 삭제 성공.")
