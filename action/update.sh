#!/bin/bash

set -o errexit

CWD=$(dirname $(realpath $0))

# Update share
if [ -d share ]; then
    cd share
    echo -e "\n-- Updating share directory"
    git pull --all --tags --force
else
    echo -e "\n-- Cloning share directory"
    git clone https://github.com/alice-adventures/project_euler-share.git share
fi

# Update participant repositories
USR=$(realpath ${CWD}/../usr/)
if [ -d "$USR" ]; then
    for repo in $(find ${USR} -mindepth 1 -maxdepth 1 -type d); do
        cd $repo >/dev/null 2>&1
        if [ -d .git ]; then
            if [ $(git branch --list | wc -l) -gt 0 ]; then
                echo -e "\n-- Updating repository usr/$(basename $repo)"
                git pull --all --tags --force
            fi
        fi
        cd - >/dev/null 2>&1
    done
fi
