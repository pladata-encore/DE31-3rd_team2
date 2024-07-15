import subprocess
from datetime import datetime

if __name__ == "__main__":
    now = datetime.now("YYmmdd")

    subprocess.run("/home/kkh/workspace/DE31-3rd_team4/smartCarProject/flume/flume_start.sh {}".format(now), shell=True)

    subprocess.run("/home/kkh/workspace/DE31-3rd_team4/smartCarProject/flume/flume_start.sh {}".format(now), shell=True)
