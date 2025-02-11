#!/bin/bash

SCRIPT_PATH=`dirname "$0"`
${SCRIPT_PATH}/remote_command.sh $@ /root/Bela/scripts/halt_board.sh
