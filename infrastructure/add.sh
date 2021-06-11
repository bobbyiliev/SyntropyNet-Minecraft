#!/bin/bash

##
# Load all ENV variables
##
export $(cat /var/www/syntropynet/.env | xargs)

lock_file=/var/www/syntropynet/infrastructure/status.lock
server_details=/var/www/syntropynet/infrastructure/server_details.temp
server_name=YXNkYXNkCg-syntropy-$(date +%s)

##
# Create new server
##

function new_server(){
    echo "New server setup in progress..." > ${lock_file}
    echo "server_name=${server_name}" > ${server_details}
    doctl auth init --access-token ${DO_API_KEY}
    new_droplet=$(doctl compute droplet create ${server_name} --size s-1vcpu-2gb --image ubuntu-20-04-x64 --region fra1 --ssh-keys ${DO_SSH_KEY} --format ID)
    new_droplet_id=$(echo $new_droplet | sed 's/ID //')

    sleep 20

    new_droplet_ip=$(doctl compute droplet get ${new_droplet_id} --template {{.PublicIPv4}})

    while [ -z ${new_droplet_ip} ] ; do
        sleep 15

        new_droplet_ip=$(doctl compute droplet get ${new_droplet_id} --template {{.PublicIPv4}})
    done

    echo "droplet_ip=${new_droplet_ip}" >> ${server_details}
    echo "New server created..." > ${lock_file}

    echo "Your new Droplet's IP address is: ${new_droplet_ip}"

}

function run_server(){
    echo "Configuration in progress..." > ${lock_file}
    ssh -i /var/www/syntropynet/config/id_rsa -o "StrictHostKeyChecking no" root@${new_droplet_ip} env SYNTROPY_AGENT_TOKEN=${SYNTROPY_AGENT_TOKEN} 'bash -s' < /var/www/syntropynet/infrastructure/minecraft_server.sh
}