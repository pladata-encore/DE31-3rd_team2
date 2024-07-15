#!/bin/bash

wget https://dlcdn.apache.org/nifi/1.27.0/nifi-1.27.0-bin.zip
sudo apt install openjdk-17-jdk

mv nifi-1.27.0 nifi
sudo mv nifi /opt/

cat "export NIFI_HOME=/opt/nifi" >> ~/.bashrc
cat "PATH=$PATH:$NIFI_HOME/bin" >> ~/.bashrc
cat "export JAVA_HOME=/usr/lib/jvm/openjdk-17-jdk" >> ~/.bashrc
cat "PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc

sudo mv ./nifi.properties /opt/nifi/conf/
sudo mv ./keystore.jks /opt/nifi/conf/
sudo mv ./truestore.jks /opt/nifi/conf/

if $1 == 1
then
	sudo mv ./encore1/nifi.properties /opt/nifi/conf/
elif $1 == 2
then
	sudo mv ./encore2/nifi.properties /opt/nifi/conf/
elif $1 == 3
then
	sudo mv ./encore3/nifi.properties /opt/nifi/conf/
fi

sudo mv ./state-management.xml /opt/nifi/conf/
sudo mv ./zookeeper.properties /opt/nifi/conf/
