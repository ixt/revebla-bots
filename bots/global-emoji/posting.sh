#!/bin/bash
# Remove all empty lines, pick top line and then post removing that line after
pushd $(dirname $0)
. ../../BotADay.sh
sed -i "/^$/d" $1
tweet=$(head -1 $1)
sed -i "/^$tweet$/d" $1
source_trc ~/.trc.globalemoji
echo "$tweet" | $tweet_script post 
popd
