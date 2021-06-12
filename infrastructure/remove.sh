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
    screen -R BungeeCord -X stuff 'greload^M'
}

function remove_from_syntropy(){
    echo "Removing server from Syntropy network..." > ${lock_file}
    new_server_id=$(syntropyctl get-endpoints | grep -w ${server_name} | awk '{ print $2 }')
    manage-network-endpoints --remove-endpoint-with-connections ${endpoint_id}
}

function remove_from_digitalocean(){
    echo "Deleting server from DigitalOcean..." > ${lock_file}
    doctl auth init --access-token ${DO_API_KEY}
    doctl compute droplet delete ${server_name}
}