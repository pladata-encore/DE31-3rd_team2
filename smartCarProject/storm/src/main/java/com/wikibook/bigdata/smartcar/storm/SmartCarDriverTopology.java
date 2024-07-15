package com.wikibook.bigdata.smartcar.storm;


import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.UUID;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.storm.Config;
import org.apache.storm.StormSubmitter;
import org.apache.storm.generated.AlreadyAliveException;
import org.apache.storm.generated.AuthorizationException;
import org.apache.storm.generated.InvalidTopologyException;
import org.apache.storm.generated.StormTopology;
// import org.apache.storm.kafka.BrokerHosts;
// import org.apache.storm.kafka.SpoutConfig;
// import org.apache.storm.kafka.StringScheme;
// import org.apache.storm.kafka.ZkHosts;
import org.apache.storm.redis.common.config.JedisPoolConfig;
import org.apache.storm.shade.com.google.common.collect.Maps;
import org.apache.storm.spout.SchemeAsMultiScheme;
import org.apache.storm.topology.TopologyBuilder;

//new code
import org.apache.storm.kafka.spout.KafkaSpout;

import org.apache.storm.kafka.spout.FirstPollOffsetStrategy;
import org.apache.storm.kafka.spout.KafkaSpoutConfig;
//------




public class SmartCarDriverTopology {


	public static void main(String[] args) throws AlreadyAliveException, InvalidTopologyException, InterruptedException, IOException, AuthorizationException {  

		StormTopology topology = makeTopology();


		Config config = new Config();
		config.setDebug(true);
		config.put(Config.NIMBUS_THRIFT_PORT, 6627);
		config.put(Config.STORM_ZOOKEEPER_PORT, 2181);
		config.put(Config.STORM_ZOOKEEPER_SERVERS, Arrays.asList("broker1"));


		config.put("storm.zookeeper.session.timeout", 20000);
		config.put("storm.zookeeper.connection.timeout", 15000);
		config.put("storm.zookeeper.retry.times", 5);
		config.put("storm.zookeeper.retry.interval", 1000);

		StormSubmitter.submitTopology(args[0], config, topology);

	}  


	private static StormTopology makeTopology() {

		String zkHost = "broker2:2181";
		TopologyBuilder driverCarTopologyBuilder = new TopologyBuilder();
		
		// BrokerHosts brkBost = new ZkHosts(zkHost);
		String topicName = "SmartCar-Topic";
		// String zkPathName = "/SmartCar-Topic";

		KafkaSpoutConfig<String, String> kafkaSpoutConfig = KafkaSpoutConfig.builder("broker1:9092",topicName).setOffsetCommitPeriodMs(10_000)
                .setFirstPollOffsetStrategy(FirstPollOffsetStrategy.EARLIEST)
                .setProp(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest")
				.setProp(ConsumerConfig.GROUP_ID_CONFIG, "my-consumer-group") 
                .build();

		// SpoutConfig spoutConf = new SpoutConfig(brkBost, topicName, zkPathName, UUID.randomUUID().toString());
		
		
		// spoutConf.scheme = new SchemeAsMultiScheme(new StringScheme());
		// spoutConf.useStartOffsetTimeIfOffsetOutOfRange=true;
		// spoutConf.startOffsetTime=kafka.api.OffsetRequest.LatestTime();
		
				 
		// KafkaSpout kafkaSpout = new KafkaSpout(spoutConf);
		KafkaSpout<String, String> kafkaSpout = new KafkaSpout<>(kafkaSpoutConfig);
		
		driverCarTopologyBuilder.setSpout("kafkaSpout", kafkaSpout);

		// Grouping - SplitBolt & EsperBolt
		// driverCarTopologyBuilder.setBolt("splitBolt", new SplitBolt(),1).allGrouping("kafkaSpout");
		driverCarTopologyBuilder.setBolt("esperBolt", new EsperBolt(),1).allGrouping("kafkaSpout");
		driverCarTopologyBuilder.setBolt("logBolt", new LogBolt("broker4",6379),1).allGrouping("kafkaSpout");


		// Redis Bolt
		RedisBolt redisBolt = new RedisBolt("broker4",6379);

		driverCarTopologyBuilder.setBolt("REDIS", redisBolt, 1).shuffleGrouping("esperBolt");

		return driverCarTopologyBuilder.createTopology();
	}

}  
