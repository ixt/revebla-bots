#!/bin/bash
# Takes reddit titles from TIFU and posts them as if headlines for "Florida man" stories
# https://twitter.com/Lord_32bit/status/938564683086356480 
pushd $(dirname $0)
. ../BotADay.sh
TEMP=$(mktemp)
TWEET=""
set_tweet(){
	TWEET=$(wget -qO- 'https://www.reddit.com/r/tifu/controversial.json?t=week&limit=100' |\
	    jq .data.children[].data.title \
	        | sed -e "s/ my / his /g" \
	              -e "s/I /He /g" \
	              -e "s/ me / him /g" \
	              -e "s/ I\(.\)ve / He\1s /g" \
	        | grep -i '^"TIFU by' \
	        | sed -e 's/^"TIFU by//gI;s/"$//g' \
	        | shuf -n1 \
			| xargs -I@ echo "Florida man arrested for @ ")
}

tweet_florida(){
	echo $TWEET
	$tweet_script post "$TWEET"
}

too_good_to_fail set_tweet tweet_florida

popd
rm -rf $TEMP
