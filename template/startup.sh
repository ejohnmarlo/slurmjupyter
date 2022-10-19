#!/bin/bash

for filename in files/*.yml; do
        docker-compose -f "$filename" down
        docker-compose -f "$filename" up -d
done
