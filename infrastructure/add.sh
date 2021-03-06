#!/bin/bash

##
# Load all ENV variables
##
export $(cat /var/www/syntropynet/.env | xargs)
infrastructure_dir=/var/www/syntropynet/infrastructure

lock_file=${infrastructure_dir}/status.lock
server_details=${infrastructure_dir}/server_details.temp
server_name=YXNkYXNkCg-syntropy-$(date +%s)

##
# Create new server
##

function new_server(){
    echo  "New server setup in progress..." > ${lock_file}
    echo  "server_name=${server_name}" > ${server_details}
    /snap/bin/doctl auth init --access-token ${DO_API_KEY}
    new_droplet=$(/snap/bin/doctl compute droplet create ${server_name} --size s-1vcpu-2gb --image docker-20-04 --region fra1 --ssh-keys ${DO_SSH_KEY} --format ID)
    new_droplet_id=$(echo $new_droplet | sed 's/ID //')

    sleep 20

    new_droplet_ip=$(/snap/bin/doctl compute droplet get ${new_droplet_id} --template {{.PublicIPv4}})

    while [ -z ${new_droplet_ip} ] ; do
        sleep 15

        new_droplet_ip=$(/snap/bin/doctl compute droplet get ${new_droplet_id} --template {{.PublicIPv4}})
    done

    echo "droplet_ip=${new_droplet_ip}" >> ${server_details}
    echo  "new_droplet_ip=${new_droplet_ip}" >> ${server_details}

    echo  "New server created..." > ${lock_file}
    echo  "Your new Droplet's IP address is: ${new_droplet_ip}"

}

function run_server(){
    echo  "Waiting for SSH connection..." > ${lock_file}
    ssh -i /var/www/syntropynet/config/id_rsa -o "StrictHostKeyChecking no" root@${new_droplet_ip} hostname
    while [ $? -ne 0 ]; do
        sleep 5
        ssh -i /var/www/syntropynet/config/id_rsa -o "StrictHostKeyChecking no" root@${new_droplet_ip} hostname
    done

    echo  "Server configuration in progress..." > ${lock_file}
    scp -i /var/www/syntropynet/config/id_rsa -o "StrictHostKeyChecking no" ${infrastructure_dir}/minecraft_server.sh root@${new_droplet_ip}:/root

    ssh -i /var/www/syntropynet/config/id_rsa -o "StrictHostKeyChecking no" root@${new_droplet_ip} env SYNTROPY_AGENT_TOKEN=${SYNTROPY_AGENT_TOKEN} bash /root/minecraft_server.sh

    range=$(grep address: ${infrastructure_dir}/config.yml  | awk '{ print $2 }'  | awk -F. '{print $2}' | sort -n | tail -1)
    range=$(( $range +1 ))
    ssh -i /var/www/syntropynet/config/id_rsa -o "StrictHostKeyChecking no" root@${new_droplet_ip} "docker network create bungee --subnet=10.${range}.0.0/16 ; docker run -d -it -p 25565:25565 --network bungee -e TYPE=SPIGOT -e ONLINE_MODE=FALSE -e EULA=TRUE itzg/minecraft-server"

    sleep 30
}

function syntropy_config(){
    echo  "Syntropy Network configuration in progress..." > ${lock_file}
    
    export SYNTROPY_API_TOKEN=${SYNTROPY_ACCESS_TOKEN}
    export SYNTROPY_API_SERVER=https://controller-prod-server.syntropystack.com

    echo  "| Get the new server endpoint id " > ${lock_file}
    current_server_id=$(/usr/local/bin/syntropyctl get-endpoints | grep -w $(hostname) | awk '{ print $2 }')
    new_server_id=$(/usr/local/bin/syntropyctl get-endpoints | grep -w ${server_name} | awk '{ print $2 }')
    /usr/local/bin/syntropyctl configure-endpoints ${new_server_id} --enable-all-services >> /tmp/endpoint.txt
    wait

    echo  "| Connect the new endpoint with the newtwork " > ${lock_file}
    /usr/local/bin/syntropyctl configure-endpoints ${new_server_id} --enable-all-services >> /tmp/endpoint.txt
    sleep 2
    /usr/local/bin/syntropyctl manage-network-endpoints BungeeCord --add-endpoint ${new_server_id}

    echo  "| Configure the BungeeCord connection " > ${lock_file}
    /usr/local/bin/syntropyctl create-connections BungeeCord ${new_server_id} ${current_server_id}

    echo  "| Get the new Minecraft Docker container IP " > ${lock_file}
    docker_endpoint_ip=$(/usr/local/bin/syntropyctl get-endpoints --id ${new_server_id} --show-services --json | grep agent_service_subnet_ip | awk '{ print $2 }' | sed 's/"//g' | sed 's/,//')
}

function proxy_config(){
    # Add the new server to the BungeeCord config
    cat ${infrastructure_dir}/temp.yaml | sed "s/S_NAME/${server_name}/g"  | sed "s/S_IP/${docker_endpoint_ip}/g" >> ${infrastructure_dir}/config.yml

    # Add the new server to the redirect plugin config
    sed -i  "/^# SERVERS LIST.*/a \      - ${server_name}" ${infrastructure_dir}/plugins/RedirectPlus/config.yml

    echo  "| Reloding the proxy " > ${lock_file}
    screen -R BungeeCord -X stuff 'rd refresh^M'
    sleep 1
    screen -R BungeeCord -X stuff 'greload^M'
}

function main(){
    # Call all functions
    new_server
    run_server
    syntropy_config
    proxy_config
    echo  "DONE" > ${lock_file}
}
main