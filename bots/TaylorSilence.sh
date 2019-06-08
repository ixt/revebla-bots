#!/bin/bash
pushd $(dirname $0)
. ../BotADay.sh
# Basically, take the top contriversial posts on reddit world news and find
# keywords using RAKE then put in the template and post a random one 
# fires @019, @089, @198 & @989
# https://twitter.com/awwang1/status/932696394414116865 
. ../BotADay.sh
TEMP=$(mktemp)
TWEET=""
set_tweet(){
	TWEET=$($RAKE_script <(wget -qO- 'https://www.reddit.com/r/worldnews/controversial.json' \
                            | jq .data.children[].data.title) \
            | cut -d, -f2 \
	        | tail -1 \
			| xargs -I@ echo "Taylor Swifts's silence on @ is deafening")
}

tweet_taylor(){
	echo $TWEET
	$tweet_script post "$TWEET"
}

too_good_to_fail set_tweet tweet_taylor

popd
rm -rf $TEMP
