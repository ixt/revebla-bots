#!/bin/bash
TEMPVID=$(mktemp --suffix=.mp4)
TEMPAUDIO=$(mktemp)
TEMPIMAGE=$(mktemp --suffix=.jpg)
TEMPIMAGE1=$(mktemp --suffix=.jpg)
TEMP=$(mktemp)
lynx -listonly -dump http://www.xeno-canto.org/explore/random \
	| grep download \
    | shuf \
	| head -1 \
	| cut -d/ -f3-4 \
	| xargs -I% lynx -dump -nonumbers % \
	| grep -E -A 2 'javascript|Citation$' \
	| sed -n "3p;7p" > $TEMP

TITLE=$(head -1 $TEMP | sed "s/.*·//g")
echo $TITLE
AUDIOATRIBUTION=$(tail -1 $TEMP)
echo $AUDIOATRIBUTION
URL=$(head -1 $TEMP | sed "s/·.*//g" | sed "s/XC//g;s/ //g")
echo $URL
wget -qO $TEMPAUDIO "https://www.xeno-canto.org/$URL/download"
CLEANTITLE=$(printf $TITLE)
echo $CLEANTITLE
KEY=$(curl "http://api.gbif.org/v1/species/search?q=$(printf $TITLE | sed -e "s/.*·//g;s/ /%20/g")"  | jq .results[1].nubKey )
echo $KEY
curl "https://www.gbif.org/species/$KEY"  > $TEMP
IMAGEATRIBUTION=$(lynx -dump -nonumbers -nolist "https://www.inaturalist.org/photos/$(
	grep "inaturalist" $TEMP \
		| grep "src" \
		| sed -e "s/.*%2F\(.*\)%2F.*/\1/g" \
		| head -1 )" \
	| grep "^Photo [0-9]" \
	| cut -d, -f2-)
grep "inaturalist" $TEMP \
	| grep "src" \
	| cut -d'"' -f2 \
	| head -1 \
	| xargs wget -O $TEMPIMAGE1
convert $TEMPIMAGE1 -scale 200% $TEMPIMAGE
yes | ffmpeg -loop 1 -i $TEMPIMAGE -i $TEMPAUDIO -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -t 00:00:30 -shortest $TEMPVID
. ~/Projects/revebla-bots/BotADay.sh
source_trc ~/.trc-bird

export VIDEO_FILENAME="$TEMPVID"
export TWEET_TEXT="$TITLE - 
Image: 
$IMAGEATRIBUTION 
Audio: 
$AUDIOATRIBUTION"
python3 ~/Projects/revebla-bots/async-upload.py
rm -rf $TEMPAUDIO $TEMPVID $TEMPIMAGE $TEMPIMAGE1
exit 0
