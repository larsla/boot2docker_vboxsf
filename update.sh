#!/bin/bash

echo "== Building image =="
docker build -t iso .

echo "== Building ISO =="
docker run --name make_iso iso

echo "== Copy ISO to boot2docker location =="
docker cp make_iso:/boot2docker.iso ~/.boot2docker/

echo "== Stopping boot2docker vm =="
boot2docker stop

echo "== Add shared folder to boot2docker vm =="
VBoxManage sharedfolder add boot2docker-vm -name Users -hostpath /Users

echo "== Start boot2docker vm =="
boot2docker start

echo "== Cleaning up =="
docker rm make_iso
#docker rmi iso
