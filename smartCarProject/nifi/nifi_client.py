import os
import logging
from datetime import datetime


class NiFiStatusLog:
    def __init__(self, log_dir):
        """
        클래스의 생성자로, log_dir라는 로그 파일을 저장할 디렉토리 경로를 인수로 받습니다.
        setup_logger 메서드를 호출하여 로거를 설정합니다.

        """
        self.log_dir = log_dir
        self.setup_logger()

    def setup_logger(self):
        """
        os.path.exists(self.log_dir): 디렉토리가 존재하는지 확인합니다.
        os.makedirs(self.log_dir): 디렉토리가 존재하지 않으면 생성합니다.
        log_filename: 현재 날짜를 기준으로 로그 파일 이름을 생성합니다.
        logging.basicConfig: 로그 메시지를 지정된 파일에 기록하도록 설정합니다.
        """
        if not os.path.exists(self.log_dir):
            os.makedirs(self.log_dir)
        log_filename = os.path.join(
            self.log_dir, f'status_log_{datetime.now().strftime("%Y%m%d")}.log'
        )
        logging.basicConfig(filename=log_filename, level=logging.INFO)

    def ingest_log(self, log_data):
        """
        로그 데이터를 기록하는 메서드입니다.
        log_data를 인수로 받아 로거를 통해 기록합니다.
        """
        logging.info(log_data)


if __name__ == "__main__":
    log_dir = "/path/to/hadoop/status_log"
    nifi_status_log = NiFiStatusLog(log_dir)
    sample_log_data = {
        "timestamp": "2024-07-13T12:00:00Z",
        "car_id": "1234",
        "status": "active",
    }
    nifi_status_log.ingest_log(sample_log_data)
