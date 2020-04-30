#!/bin/bash

for name in kibana logstash elasticsearch; do
    id=`docker ps | grep $name | awk '{print $1}'`
    if [ ! -z "$id" ]; then
        echo -n "Killing $name... "
        docker kill $id
        if [ "$name" != "logstash" ]; then
            echo -n "Removing container $name... "
            docker rm $id
        fi
    fi
done

