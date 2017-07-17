#!/usr/bin/env sh
# Author: Jins Yin <jinsyin@gmail.com>

created_containers=$(docker ps -a | grep 'Created' | awk '{print $1}')

if [ -n "${created_containers}" ]; then docker rm -f -v ${created_containers}; fi

