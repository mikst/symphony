#!/bin/bash

# ./sync.sh
# ./sync.sh 1
# ./sync.sh 1 100

SRC_FOLDER=/Users/mikst/Documents/_PROJECT/jupiter/PD/Strahl/symphony_v2/
DST_FOLDER=/root/Bela/projects/symphony
IP_PREFIX="192.168.0."

#192.168.0.101 = 1
#..
#192.168.0.180 = 80

FROM_ID=1
TO_ID=80

# echo "uno ${1}"
# echo "dos ${2}"

if [ -z ${1+x} ]; then
    echo "syncing everything? (y/n)"
    read sure
    if [ "$sure" != "y" ]; then
        exit
    fi
else
    FROM_ID=$1
fi

if [ -z ${2+x} ]; then
    # $2 not set
    if [[ "$1" ]]; then
        # 1 was set
        TO_ID=$1
    fi
else
    TO_ID=$2
fi

FROM_ID=$((FROM_ID + 100))
TO_ID=$((TO_ID + 100))

if (( FROM_ID < 101 )); then
    echo "invalid range. id must be >= 1"
    exit
fi

if (( FROM_ID >= 200 )); then
    echo "invalid range. id must be < 100"
    exit
fi

if (( TO_ID < FROM_ID )); then
    echo "invalid range. from-ip must be <= to-ip"
    exit
fi


echo "sycing from ${FROM_ID} to ${TO_ID}"


for (( i = $FROM_ID; i <= $TO_ID; i++ )) 
do
    IP=${IP_PREFIX}${i}
    echo "    
syncing ${IP}"

    # try to ping device
    # check result of command (option -o: Exit successfully after receiving one reply packet)
    RES=`ping -o -t 1 -W 1 -c 1 ${IP}`

    if (( $? == 0 )); then
        echo "running rsync for ${IP}"
        rsync -azP --delete -e "ssh -o StrictHostKeyChecking=no" --exclude 'settings.json' --exclude 'build' ${SRC_FOLDER} root@${IP_PREFIX}${i}:${DST_FOLDER}
    else
        echo "could not ping ${IP}"
    fi
done
