#!/bin/bash

# usage:
# remote_command id1 [id2] command

# commands
# run project
# ./remote_command.sh id1 id2 /root/Bela/scripts/run_project.sh -b symphony
# stop running
# ./remote_command.sh id1 id2 /root/Bela/scripts/stop_running.sh


IP_PREFIX="192.168.0."
# if bela is on cable
# IP_PREFIX="192.168.7."

# vars
IP_OFFSET=100
FROM_ID=1
TO_ID=80
COMMAND=
ARGS=($@)

print_udage () {
    echo
    echo "usage:"
    echo "remote_command id1 [id2] command"
    echo
    echo "id1:      from-id (1..99)"
    echo "id2:      to-id, optional (1..99). if not specified id1 is used. (id1 <= id2)"
    echo "command:  the command to execute on the device in the range specified"
    echo
}

case $1 in
    ''|*[!0-9]*)
        echo "run command on all devices? (y/n)"
        read sure
        if [ "$sure" != "y" ]; then
            exit
        fi
        COMMAND=("${ARGS[@]}")
    ;;
    *) FROM_ID=$1; TO_ID=$1; COMMAND=("${ARGS[@]:1}") ;;
esac

case $2 in
    ''|*[!0-9]*) ;;
    *) TO_ID=$2; COMMAND=("${ARGS[@]:2}") ;;
esac

# add offset
FROM_ID=$((FROM_ID + IP_OFFSET))
TO_ID=$((TO_ID + IP_OFFSET))

# check if command exists
if [ -z ${COMMAND+x} ]; then
    echo "no command specified"
    print_udage
    exit
fi

# check from
if (( FROM_ID < 101 )); then
    echo "invalid range. id must be >= 1"
    exit
fi

if (( FROM_ID >= 200 )); then
    echo "invalid range. id must be < 100"
    exit
fi

# check to
if (( TO_ID < FROM_ID )); then
    echo "invalid range. from-ip must be <= to-ip"
    exit
fi


# if bela is on cable
# FROM_ID=2
# TO_ID=2


# arguments seem fine - continue


# echo from: $FROM_ID
# echo to: $TO_ID
# echo command: ${COMMAND[@]}
# echo "running command '${COMMAND[@]}' on devices from ${FROM_ID} to ${TO_ID}"

for (( i = $FROM_ID; i <= $TO_ID; i++ )) 
do
    IP=${IP_PREFIX}${i}

    # try to ping device
    # check result of command
    # INFO: option -o: Exit successfully after receiving one reply packet
    RES=`ping -o -t 1 -W 1 -c 10 ${IP}`

    if (( $? == 0 )); then
        echo "
running command '${COMMAND[@]}' on ${IP}"
        ssh -o StrictHostKeyChecking=no root@${IP} "${COMMAND[@]}"
    else
        echo "
could not ping ${IP}"
    fi
done
