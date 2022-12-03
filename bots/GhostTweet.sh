#!/bin/bash 
CURRENTDIR=$(dirname $0)
set -x
pushd $CURRENTDIR
. ../BotADay.sh
TWEET_ID=$($tweet_script post -i "../data/ghost.jpg" "boo!" | jq -r ".id_str")
sleep 2s
$tweet_script delete $TWEET_ID
popd
