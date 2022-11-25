#!/bin/bash
# Basically, take the top contriversial posts on reddit world news and find
# keywords using RAKE then put in the template and post a random one 
# fires @019, @089, @198 & @989
# https://twitter.com/awwang1/status/932696394414116865 
pushd $(dirname $0)
. ../BotADay.sh
TEMP=$(mktemp)
TWEET=""
set_tweet(){
	TWEET=$($RAKE_script <(wget -qO- 'https://www.reddit.com/r/worldnews/controversial.json' \
                            | jq -r .data.children[].data.title) \
            | cut -d, -f2 \
	        | tail -1 \
			| xargs -I@ echo "Taylor Swifts's silence on @ is deafening")
}

tweet_taylor(){
	echo $TWEET
	# $tweet_script post "$TWEET"
}

set_tweet 
tweet_taylor

$RAKE_script <(wget -qO- 'https://www.reddit.com/r/worldnews/controversial.json' \
    | jq -r .data.children[].data.title)
popd
rm -rf $TEMP
