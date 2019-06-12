#!/bin/bash 
CURRENTDIR=$(dirname $0)
TWEET_ID=$(t update "boo!" -f "$CURRENTDIR/../data/ghost.jpg" | grep "status" | cut -d" " -f5 | sed -e"s/\`//g")
sleep 1s
yes | t delete status $TWEET_ID
