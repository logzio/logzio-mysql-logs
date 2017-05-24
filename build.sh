#!/bin/bash

export TAG="logzio/mysql-logs:latest"

docker build -t $TAG ./

echo "Built: $TAG"
