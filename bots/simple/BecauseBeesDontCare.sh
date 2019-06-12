#!/bin/bash
# https://twitter.com/_Kwasimoto/status/928126952782917632
# Tweets a line of the bee movie script every 12 hours in order
SCRIPTDIR=$(dirname $0)
pushd $SCRIPTDIR 
. ../../BotADay.sh
$tweet_script post "$(sed -n 1p ../../data/.beemoviescript)" \
    && sed -i 1d ../../data/.beemoviescript
popd
