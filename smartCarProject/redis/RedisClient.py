import redis.asyncio as redis
import asyncio
import os


import datetime


class RedisClient:
    redis_pool = None

    def __init__(self, key):
        self.key = key
        global redis_pool
        print("PID %d: initializing redis pool..." % os.getpid())
        redis_pool = redis.ConnectionPool(host="192.168.0.204", port=6379, db=0)
        self.redis = None

    async def connect(self):
        self.redis = await redis.Redis(connection_pool=redis_pool)

    async def run(self):
        await self.connect()
        cnt = 1

        try:
            while True:
                over_speed_car_list = await self.redis.smembers(self.key)
                print("################################################")
                print("#####   Start of The OverSpeed SmartCar    #####")
                print("################################################")
                print(f"\n[ Try No.{cnt}]")
                cnt += 1

                if len(over_speed_car_list) > 0:
                    for car in over_speed_car_list:
                        print(
                            f'[{datetime.datetime.now()}] value: {car.decode("utf-8")}'
                        )
                    print("")
                    # await self.redis.delete(self.key) # 삭제 코드
                else:
                    print("\nEmpty Car List...\n")

                print("################################################")
                print("######   End of The OverSpeed SmartCar    ######")
                print("################################################")
                print("\n\n")

                await asyncio.sleep(10)
        except Exception as e:
            print(e)
        finally:
            self.redis.close()
            await self.redis.wait_closed()


if __name__ == "__main__":
    key = str(datetime.datetime.now())[:10]
    key = key.replace("-", "")
    client = RedisClient(key)
    asyncio.run(client.run())
