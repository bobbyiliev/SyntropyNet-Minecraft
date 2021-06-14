#!/bin/bash

function setup_server(){

    echo  "| Start the Syntropy agent in Docker "

    docker run --network="host" --restart=on-failure:10 --cap-add=NET_ADMIN   --cap-add=SYS_MODULE -v /var/run/docker.sock:/var/run/docker.sock:ro   --device /dev/net/tun:/dev/net/tun --name=syntropynet-agent   -e SYNTROPY_API_KEY=${SYNTROPY_AGENT_TOKEN}   -e SYNTROPY_NETWORK_API='docker' -d syntropynet/agent:stable

}

setup_server