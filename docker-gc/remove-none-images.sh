#!/usr/bin/env sh
# Author: Jins Yin <jinsyin@gmail.com>

none_images=$(docker images | grep 'none' | awk '{print $3}')

if [ -n "${none_images}" ]; then docker rmi -f ${none_images}; fi