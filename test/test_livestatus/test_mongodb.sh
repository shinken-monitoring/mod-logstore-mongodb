#!/bin/sh

MODULE_DIR=$(readlink -f $(dirname "$0"))
DIR=$MODULE_DIR/../../..
echo "$DIR" > /tmp/dump

if [ "$DIR" = "" ]; then
    echo "DIR MUST NOT BE EMPTY. I WONT TRY TO REMOVE /TMP"
    exit 2
fi

if [ "$1" = "start" ]; then
    if [ ! -d "$DIR/mongodb" ]; then
        mkdir "$DIR/mongodb"
    fi
    mongod --dbpath $DIR/mongodb --smallfiles --pidfilepath $DIR/pid.txt --fork --logpath $DIR/log.txt & 
elif [ "$1" = "stop" ]; then
    kill $(cat $DIR/pid.txt)
    rm -rf $DIR/mongodb/* $DIR/pid.txt $DIR/log.txt
else
    echo "Option $1 not recognized"
fi

sleep 3
