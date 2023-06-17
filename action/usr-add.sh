#!/bin/bash

set -o errexit

CWD=$(dirname $(realpath $0))
cd $CWD/../

[[ -z $1 ]] && echo "Usage: $0 USERNAME" && exit 1

NAME=$(echo -e "$1" | tr -s ' ' | sed 's/^ *//;s/ *$//')
[[ -d usr/$NAME ]] && echo "Error: user '$NAME' already exists" && exit 1

mkdir usr/$NAME
cd usr/$NAME
ln -s ../../assets .
ln -s ../../share/input .
# ln -s ../../css .
# ln -s ../../html .
# ln -s ../../js .

echo
echo "  Directory user/$NAME successfully created!"
echo
echo "  Go to this directory, 'cd usr/$NAME'"
echo "   and run the following commands:"
echo
echo "  1. To start using Alire:"
echo "     alr init --bin --in-place alice_project_euler_$NAME"
echo
echo "  2. To use the local project_euler crate:"
echo "     alr with project_euler --use ../../"
echo
echo "  3. Remember to create your own repository:"
echo "     git init ."
echo
echo "  NOTE: If you do NOT plan to use the GUI Interface, then"
echo "        you can safely remove the symlinks css, html and js"
echo
