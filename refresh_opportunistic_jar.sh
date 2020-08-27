#! /bin/sh

cp ../opportunistic_marathon/target/scala-2.13/marathon_2.13-1.10.25.jar marathon/mesosphere.marathon.marathon-1.10.25.jar
sudo docker-compose down
sudo docker-compose up --build -d
