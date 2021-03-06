#!/bin/bash
apt-get update && apt-get install -y iputils-ping
connectendpoint=`ping -c 1 connect | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

 
echo "**********************************************" ${connectendpoint}
echo "Waiting for startup.."
# until $(curl -s -o /dev/null -w ''%{http_code}''  http://connect:8083/connectors) != "200" do
#   printf '.'
#   sleep 1
# done

echo "Started.."

echo cdcsetup.sh time now: `date +"%T" `
apt-get update && apt-get install -y iputils-ping && apt install curl

#create connector
echo "------------------------------ CREATING A CONNECTOR TO MONGO ------------------------------"
sleep 45
curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{
    "name": "mongodb-connector",
    "config": {
      "connector.class": "io.debezium.connector.mongodb.MongoDbConnector",
      "mongodb.hosts": "rs0/mongo1:27017",
      "mongodb.name": "rawmaterial",
      "database.whitelist": "inventory",
      "key.converter":"org.apache.kafka.connect.storage.StringConverter",
      "key.converter.schemas.enable":"false",
      "value.converter":"org.apache.kafka.connect.storage.StringConverter",
      "value.converter.schemas.enable":"false"
    }
}' http://connect:8083/connectors/
