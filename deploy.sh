#!/bin/bash

docker build -t jmdalmeida/multi-client:latest -t jmdalmeida/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jmdalmeida/multi-server:latest -t jmdalmeida/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jmdalmeida/multi-worker:latest -t jmdalmeida/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jmdalmeida/multi-client:latest
docker push jmdalmeida/multi-server:latest
docker push jmdalmeida/multi-worker:latest

docker push jmdalmeida/multi-client:$SHA
docker push jmdalmeida/multi-server:$SHA
docker push jmdalmeida/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=jmdalmeida/multi-client:$SHA
kubectl set image deployments/server-deployment server=jmdalmeida/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=jmdalmeida/multi-worker:$SHA
