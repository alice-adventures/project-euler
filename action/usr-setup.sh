#!/bin/bash

set -o errexit

CWD=$(dirname $(realpath $0))

mapfile < <(cat usr/.register)
for i in ${!MAPFILE[*]}; do
    NAME=$(echo ${MAPFILE[$i]} | cut -f1 -d' ')
    REPO=$(echo ${MAPFILE[$i]} | cut -f2 -d' ')
    if [ ! -d usr/$NAME ]; then
        git clone $REPO usr/$NAME
        cd usr/$NAME
        ln -s ../../css .
        ln -s ../../html .
        ln -s ../../share/input .
        ln -s ../../js .
    fi;
done
