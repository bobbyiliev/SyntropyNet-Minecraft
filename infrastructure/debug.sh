#!/bin/bash

export $(cat /var/www/syntropynet/.env | xargs)
infrastructure_dir=/var/www/syntropynet/infrastructure

lock_file=${infrastructure_dir}/remove.lock
server_details=${infrastructure_dir}/server_details.temp
server_name=YXNkYXNkCg-syntropy-$(date +%s)

function main(){
    echo  "New server setup in progress... $1" > ${lock_file}
    sleep 3s
    echo  "server_name=${server_name} $1" > ${server_details}
    sleep 3s
    echo  "new_droplet_ip=${new_droplet_ip}" >> ${server_details}
    sleep 3s
    echo  "New server created... $1" > ${lock_file}
    sleep 3s
    echo  "Your new Droplet's IP address is: ${new_droplet_ip}"
    sleep 3s
    echo  "Server configuration in progress... $1" > ${lock_file}
    sleep 3s
    echo  "Syntropy Network configuration in progress... $1" > ${lock_file}
    sleep 3s
    echo  "| Get the new server endpoint id  $1" > ${lock_file}
    sleep 3s
    echo  "| Connect the new endpoint with the newtwork  $1" > ${lock_file}
    sleep 3s
    echo  "| Configure the BungeeCord connection  $1" > ${lock_file}
    sleep 3s
    echo  "| Get the new Minecraft Docker container IP  $1" > ${lock_file}
    sleep 3s
    echo  "| Reloding the proxy  $1" > ${lock_file}
    sleep 3s
    echo  "DONE" > ${lock_file}
}
main