#!/bin/bash
#   20181230 - BlewMe.sh - Reply to recent tweets with over 5 likes on the
#   selected account and reply with "damn this blew up 😳😳"
#   https://ff4500.red/projects/BoaDaBoA/
# https://twitter.com/neon484/status/1070060918749319168
set -euo pipefail
IFS=$'\n\t'
# Source 
SCRIPTDIR=$(dirname $0)
LATESTTWEETS=$(mktemp)
pushd $SCRIPTDIR 
. ../BotADay.sh

# Make sure we have a file for tweets we have seen
touch ../data/_xs.seenids

printf "Getting tweets\n"

$tweet_script fetch-tweets | jq .[].id
        > $LATESTTWEETS

printf "Got tweets\n"

while read tweet; do
    IFS="," read -a tweet_info <<< "$tweet"

    grep -q "${tweet_info[0]}" ../data/_xs.seenids \
        && echo "Seen tweet ${tweet_info[0]}" \
        && continue

    printf "Checking tweet ${tweet_info[0]}\n"

    faves=$($tweet_script fetch ${tweet_info[0]} | jq .favorite_count)
    if [[ "$faves" -gt 10 ]]; then
        $tweet_script reply ${tweet_info[0]} "damn this blew up 😳😳"
        echo ${tweet_info[0]} >> ../data/_xs.seenids
    fi
done < <(tail -n +2 $LATESTTWEETS)

printf "Done\n"

popd
rm $LATESTTWEETS
