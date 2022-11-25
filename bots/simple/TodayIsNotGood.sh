#!/bin/bash
# https://twitter.com/craigbased/status/991683967622332416
pushd $(dirname $0)
. ../../BotADay.sh
source_trc ~/.trc.notgood 
$tweet_script post "Today will not be good"
popd
