#!/bin/bash

export $(cat /var/www/syntropynet/.env | xargs)
infrastructure_dir=/var/www/syntropynet/infrastructure

server_details=${infrastructure_dir}/server_details.temp
#server_name=YXNkYXNkCg-syntropy-$(date +%s)
server_name=${1}

lock_file=${infrastructure_dir}/remove.lock
if [[ -z $server_name ]] ; then
    lock_file=${infrastructure_dir}/status.lock
fi

function main(){
    echo  "New server setup in progress... ${server_name}" > ${lock_file}
    sleep 3s
    echo  "server_name=${server_name} ${server_name}" > ${server_details}
    sleep 3s
    echo  "new_droplet_ip=${new_droplet_ip}" >> ${server_details}
    sleep 3s
    echo  "New server created... ${server_name}" > ${lock_file}
    sleep 3s
    echo  "Your new Droplet's IP address is: ${new_droplet_ip}"
    sleep 3s
    echo  "Server configuration in progress... ${server_name}" > ${lock_file}
    sleep 3s
    echo  "Syntropy Network configuration in progress... ${server_name}" > ${lock_file}
    sleep 3s
    echo  "| Get the new server endpoint id  ${server_name}" > ${lock_file}
    sleep 3s
    echo  "| Connect the new endpoint with the newtwork  ${server_name}" > ${lock_file}
    sleep 3s
    echo  "| Configure the BungeeCord connection  ${server_name}" > ${lock_file}
    sleep 3s
    echo  "| Get the new Minecraft Docker container IP  ${server_name}" > ${lock_file}
    sleep 3s
    echo  "| Reloding the proxy  ${server_name}" > ${lock_file}
    sleep 3s
    echo  "DONE" > ${lock_file}
}
main