#!/bin/bash

PROJECT_FOLDER=/root/Bela/projects/
IP_PREFIX="192.168.0."


if [ -z ${1+x} ]; then
    echo "no id set.
usage: ll.sh <ID> <project folder>
"
    echo "ID: 1..99 (mandatory)"
    echo "the project folder is optional
    "
    exit
fi

ID=$(($1 + 100))

if (( ID < 101 )); then
    echo "invalid range. id must be >= 1"
    exit
fi

if (( ID >= 200 )); then
    echo "invalid range. id must be < 100"
    exit
fi

IP=${IP_PREFIX}${ID}

RES=`ping -o -t 1 -W 1 -c 1 ${IP}`

if (( $? == 0 )); then
    ssh root@${IP} "ls -l ${PROJECT_FOLDER}${2}"
else
    echo "could not ping ${IP}"
fi