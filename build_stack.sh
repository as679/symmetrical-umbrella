#!/bin/bash

elasticid=`docker ps | grep elasticsearch | awk '{print $1}'`
if [ -z "$elasticid" ]; then
    echo -n "Starting elasticsearch... "
    docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" --name elasticsearch docker.elastic.co/elasticsearch/elasticsearch:7.6.2
    elasticid=`docker ps | grep elasticsearch | awk '{print $1}'`
else
    echo "elasticsearch already running... $elasticid"
fi

logsid=`docker ps | grep logstash | awk '{print $1}'`
if [ -z "$logsid" ]; then
    echo -n "Starting logstash... "
    docker run -d --link $elasticid:elasticsearch --rm -it -v ~/logstash-pipelines/:/usr/share/logstash/pipeline/ --name logstash -p 5000:5000/udp -p 5001:5001 docker.elastic.co/logstash/logstash:7.6.2
else
    echo "logstash already running... $logsid"
fi

kibid=`docker ps | grep kibana | awk '{print $1}'`
if [ -z "$kibid" ]; then
    echo -n "Starting kibana... "
    docker run -d --link $elasticid:elasticsearch -p 5601:5601 --name kibana docker.elastic.co/kibana/kibana:7.6.2
else
    echo "kibana already running... $kibid"
fi

