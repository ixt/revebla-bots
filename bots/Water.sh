#!/bin/bash
# Search for all the drink glasses of water tweets and extract the number of glasses and take a mean average
pushd $(dirname $0)
. ../BotADay.sh
average=$($tweet_script search -q 'Drink \* glasses of water' \
    | jq -r .statuses[].text \
    | sed -e "s/[^0-9. -]//g" \
    | sed -e "s/ /\n/g" \
    | grep -e "[0-9]" \
    | sed -e "s/^\.//g" \
    | datamash mean 1 \
    | cut -d. -f1)
$tweet_script post "Remember to drink $average glasses of water a day! #PSA"
popd
