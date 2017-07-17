#!/usr/bin/env sh
# Author: Jins Yin <jinsyin@gmail.com>

local_volumes=$(docker volume ls | grep 'local' | awk '{print $2}')

if [ -n "${local_volumes}" ]; then docker volume rm -f ${local_volumes}; fi