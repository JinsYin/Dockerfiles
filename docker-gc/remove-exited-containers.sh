#!/usr/bin/env sh
# Author: Jins Yin <jinsyin@gmail.com>

exited_containers=$(docker ps -a | grep 'Exited' | awk '{print $1}')

if [ -n "${exited_containers}" ]; then docker rm -f -v ${exited_containers}; fi

