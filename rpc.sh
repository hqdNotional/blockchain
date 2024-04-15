#!/bin/bash

read -p "Enter service name [bitsong]:" service

TASK_IDS=$(docker service ps $(docker service ls | grep $service | grep -E "rpc_$service\\_" | awk '{print $2}') | awk '{print $1}')
NODES=$(docker service ps $(docker service ls | grep $service | grep -E "rpc_$service\\_" | awk '{print $2}') | awk '{print $4}')

for node in $NODES
do
   echo "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$node"
done

for task_id in $TASK_IDS
do
  container_id=$(docker inspect -f '{{ .Status.ContainerStatus.ContainerID }}' $task_id)
  echo "docker exec -it $container_id /bin/bash"
done

