package com.wikibook.bigdata.smartcar.storm;

import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.exceptions.JedisConnectionException;

import java.util.Map;

public class LogBolt extends BaseRichBolt {

    private OutputCollector collector;
    private JedisPool jedisPool;
    private static final String REDIS_HOST = "broker4";
    private static final int REDIS_PORT = 6379;

    public LogBolt(String redisHost, int redisPort) {
        JedisPoolConfig poolConfig = new JedisPoolConfig();
        poolConfig.setMaxTotal(128);
        poolConfig.setMaxIdle(128);
        poolConfig.setMinIdle(16);
        poolConfig.setTestOnBorrow(true);
        poolConfig.setTestOnReturn(true);
        poolConfig.setTestWhileIdle(true);
        // this.jedisPool = new JedisPool(poolConfig, redisHost, redisPort);
    }

    @Override
    public void prepare(Map stormConf, TopologyContext context, OutputCollector collector) {
        this.collector = collector;
    }

    @Override
    public void execute(Tuple input) {
        String log = input.getStringByField("value");

        Jedis jedis = null;
        try {
            jedis = new Jedis(REDIS_HOST, REDIS_PORT);
            jedis.sadd("flume_key", log);
            jedis.expire("flume_key", 604800);

            // 처리 완료를 Storm에 알림
        } catch (JedisConnectionException e) {
            throw new RuntimeException("Exception occurred to JedisConnection", e);
        } catch (Exception e) {
            System.out.println("Exception occurred from Jedis/Redis: " + e);
        } finally {
            if (jedis != null) {
                jedis.close(); // 리소스 반환
            }
            collector.ack(input);
        }
    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        // 필요에 따라 출력 필드 선언
    }
}