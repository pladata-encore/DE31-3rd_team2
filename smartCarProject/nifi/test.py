import unittest
from nifi_client import NiFiStatusLog
import os
from datetime import datetime


class TestNiFiStatusLog(unittest.TestCase):
    def test_ingest_log(self):
        # 테스트용 로그 디렉토리를 설정합니다.
        log_dir = "./test_logs"

        # NiFiStatusLog 클래스의 인스턴스를 생성합니다.
        status_log = NiFiStatusLog(log_dir)

        # 샘플 로그 데이터를 생성합니다.
        sample_log_data = {
            "timestamp": "2024-07-13T12:00:00Z",
            "car_id": "1234",
            "status": "active",
        }

        # 샘플 로그 데이터를 기록합니다.
        status_log.ingest_log(sample_log_data)

        # 현재 날짜에 기반한 로그 파일 이름을 생성합니다.
        log_filename = os.path.join(
            log_dir, f'status_log_{datetime.now().strftime("%Y%m%d")}.log'
        )

        # 생성된 로그 파일을 읽어 샘플 로그 데이터가 포함되어 있는지 확인합니다.
        with open(log_filename, "r") as log_file:
            logs = log_file.read()
            self.assertIn(str(sample_log_data), logs)


if __name__ == "__main__":
    # 모든 유닛 테스트를 실행합니다.
    unittest.main()
