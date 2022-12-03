#!/bin/bash
#set -euo pipefail
IFS=$'\n\t'
TOOLDIR="/home/orange/Projects/botadaybotaway/Tools"
DATADIR="/home/orange/Projects/revebla-bots/data"
export PATH=$PATH:$TOOLDIR
tweet_script="/home/orange/Projects/tweet.sh/tweet.sh"
RAKE_script=$TOOLDIR/RAKE.sh/RAKE.sh
DEBUG=0

quote_repeating_week(){
    # $1 - Quote file
    # $2 - Source quote
    local QUOTEFILE="$1"
    local PERSON="$2"
    local SECONDSSINCEMIDNIGHT=$(( $( TZ=":Etc/GMT-1" date "+(10#%H * 60 + 10#%M) * 60 + 10#%S") )) 
    local AMOUNTOFQUOTES=$(wc -l $QUOTEFILE \
                        | cut -d" " -f1 )
    
    local BEATS=$(echo "scale=5;($SECONDSSINCEMIDNIGHT / 86400)*1000" \
        | bc \
        | cut -d. -f1)
    
    local DAYOFWEEK=$(date +%w)
    local VALUE=$( bc -l <<< "scale=0;($BEATS + ( $DAYOFWEEK * 1000)) / (7000 / $AMOUNTOFQUOTES) " )
    
    local QUOTE=$(sed -n ${VALUE}p $QUOTEFILE)
    echo «${QUOTE}» - ${PERSON} >&2
    $tweet_script post "«${QUOTE}» - ${PERSON}" 
}

too_good_to_fail(){
    local Notworking=1
    while [[ "$Notworking" -gt "0" ]]; do
        [[ "$DEBUG" == "1" ]] && echo "too good to fail loop $1 & $2"
    	bash $1
    	bash $2
    	Notworking="$?"
        [[ "$DEBUG" == "1" ]] && echo $Notworking
    done
}

archive_name(){
    local DATE=$(date +%s)
    local USER="$1"
    touch $DATADIR/$USER.sums $DATADIR/$USER.names
    local NAME=$($tweet_script fetch-tweets -u $USER -c 1 | jq -r .[].user.name)
    local SUM=$(md5sum <<< "$NAME" | cut -d" " -f1)
    if ! grep -q $SUM $DATADIR/$USER.sums; then
        $tweet_script post "New Display name: "$NAME" #$USER"
        echo $SUM >> $DATADIR/$USER.sums
        echo $DATE: $NAME >> $DATADIR/$USER.names
    fi
}

screenshot(){
    # We repeat this 4 times just to make it takes it 
    local url="$1"
    local screenshot="$2"
    local width="$3"
    local height="$4"
    local fileSize="0"
    echo "[INFO]: Screenshot"
        if [ -e "/usr/bin/chromium" ]; then
        chromium --headless --disable-gpu ${url} --hide-scrollbars --virtual-time-budget=120000 --window-size=${width},${height} --force-device-scale-factor=2 --hide-scroll-bars --screenshot=${screenshot}
        else
        chromium-browser --headless --disable-gpu ${url} --hide-scrollbars --virtual-time-budget=120000 --window-size=${width},${height} --force-device-scale-factor=2 --hide-scroll-bars --screenshot=${screenshot}
        fi
}

source_trc(){
    source <(yq ".profiles[][]" $1 --yaml-output \
        | sed -e "s/username/MY_SCREEN_NAME/" \
              -e "s/consumer/CONSUMER/g;s/secret/SECRET/g;s/key/KEY/;s/token/ACCESS_TOKEN/g;s/^SECRET/ACCESS_TOKEN_SECRET/g" \
              -e "s/: /=/g" -e "s/^/export /g")
    export MY_LANGUAGE="en-GB"
    $tweet_script whoami
}
