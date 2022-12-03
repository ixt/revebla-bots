#!/bin/bash

source ./BotADay.sh
source_trc ~/.trc-bird
$tweet_script fetch-tweets -u _xs -c 1 | jq .[].user.name
