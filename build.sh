#!/bin/bash

export TAG="logzio/postgresql-logs:latest"

docker build -t $TAG ./

echo "Built: $TAG"
