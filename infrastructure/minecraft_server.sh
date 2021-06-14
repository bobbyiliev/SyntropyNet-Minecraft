#!/bin/bash

function setup_server(){

    echo  "| Installing Docker "
    snap install docker
    wait

    sleep 5
    echo  "| Start the Syntropy agent in Docker "

    /snap/bin/docker run --network="host" --restart=on-failure:10 --cap-add=NET_ADMIN   --cap-add=SYS_MODULE -v /var/run/docker.sock:/var/run/docker.sock:ro   --device /dev/net/tun:/dev/net/tun --name=syntropynet-agent   -e SYNTROPY_API_KEY=${SYNTROPY_AGENT_TOKEN}   -e SYNTROPY_NETWORK_API='docker' -d syntropynet/agent:stable
    wait

    CHECK_SWAP=$(swapon -s | wc -l)
    if [ $CHECK_SWAP -lt 1 ] ; then

        echo  "| Adding swap file "

        # Create a swap file
        sudo fallocate -l 1G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile

        # Making the swap file permanent
        sudo cp /etc/fstab /etc/fstab.bak
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    fi

    /snap/bin/docker network create bungee
    wait

    /snap/bin/docker run -d -it -p 25565:25565 --network bungee -e TYPE=SPIGOT -e ONLINE_MODE=FALSE -e EULA=TRUE itzg/minecraft-server
    wait
}

setup_server