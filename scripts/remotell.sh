#!/bin/bash

PROJECT_FOLDER=/root/Bela/projects/
IP_PREFIX="192.168.0."

# if bela is on cable
#IP_PREFIX="192.168.6."

IP_OFFSET=100


print_usage () {
    echo
    echo "usage:"
    echo "remotell.sh id project_folder"
    echo
    echo "id:               device-id (1..99)"
    echo "project_folder:   optional"
    echo
}


if [ -z ${1+x} ]; then
    echo "invalid range: no id set"
    print_usage
    exit
fi

ID=$(($1 + IP_OFFSET))

if (( ID < 101 )); then
    echo "invalid range: id must be >= 1"
    exit
fi

if (( ID >= 200 )); then
    echo "invalid range: id must be < 100"
    exit
fi

# if bela is on cable
# ID=2

IP=${IP_PREFIX}${ID}

RES=`ping -o -t 1 -W 1 -c 1 ${IP}`

if (( $? == 0 )); then
    ssh -o StrictHostKeyChecking=no root@${IP} "ls -l ${PROJECT_FOLDER}${2}"
else
    echo "could not ping ${IP}"
fi