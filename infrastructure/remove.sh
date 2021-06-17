#!/bin/bash

##
# Accept the server name which needs to be deleted as an argument
##

#TODO

##
# Load all ENV variables
##
export $(cat /var/www/syntropynet/.env | xargs)
infrastructure_dir=/var/www/syntropynet/infrastructure

server_name=${1}
lock_file=${infrastructure_dir}/remove.lock

function remove_from_proxy(){
    echo "Removing server from proxy..." > ${lock_file}
    sed -i -e  "/${server_name}/,+3d" ${infrastructure_dir}/config.yml

    sed -i "/^      - ${server_name}/d" ${infrastructure_dir}/plugins/RedirectPlus/config.yml

    echo "Restarting the proxy server..." > ${lock_file}
    screen -R BungeeCord -X stuff 'rd refresh^M'
    sleep 1
    screen -R BungeeCord -X stuff 'greload^M'
}

function remove_from_syntropy(){
    echo "Removing server from Syntropy network..." > ${lock_file}
    export SYNTROPY_API_TOKEN=${SYNTROPY_ACCESS_TOKEN}
    export SYNTROPY_API_SERVER=https://controller-prod-server.syntropystack.com

    endpoint_id=$(/usr/local/bin/syntropyctl get-endpoints | grep -w ${server_name} | awk '{ print $2 }')
    wait
    sleep 1
    /usr/local/bin/syntropyctl manage-network-endpoints --remove-endpoint-with-connections ${endpoint_id} BungeeCord  >> /tmp/endpoint.txt
}

function remove_from_digitalocean(){
    echo "Deleting server from DigitalOcean..." > ${lock_file}
    /snap/bin/doctl auth init --access-token ${DO_API_KEY}
    /snap/bin/doctl compute droplet delete ${server_name} --force
}

function main(){
    remove_from_proxy
    remove_from_syntropy
    remove_from_digitalocean
    echo "DONE" > ${lock_file}
}
main