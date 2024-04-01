#!/bin/bash

read -p "Enter service name [bitsong]:" service
SWARM_NODE=$(docker service ps $(docker service ls | grep $service | grep -E "rpc_$service\\_" | awk '{print $2}') | awk '{print $4}')
CONTAINER_ID=$(docker service ps $(docker service ls | grep $service | grep -E "rpc_$service\\_" | awk '{print $2}') | awk '{print $1}')

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$SWARM_NODE "docker exec -it $CONTAINER_ID /bin/bash"
