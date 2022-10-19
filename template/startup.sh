#!/bin/bash

for filename in /root/students/files/*.yml; do
        sudo docker-compose -f "$filename" down
        sudo docker-compose -f "$filename" up -d
done
