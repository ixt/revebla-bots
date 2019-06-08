#!/bin/bash
# Archives the names of people, both by appending a name & tweeting it 
# https://twitter.com/ElSangito/status/764301074001899520 

pushd $(dirname $0)
. ../BotADay.sh

USERS=( "ElSangito" "_xs" )
    for USER in ${USERS[@]}; do
        archive_name "$USER"
    done
popd
