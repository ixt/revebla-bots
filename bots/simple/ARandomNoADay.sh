#!/bin/bash
NUMBER="$RANDOM"
pushd $(dirname $0)
. ../../BotADay.sh
source_trc ~/.trc.randomnoaday
if [[ $(( $NUMBER % 2 )) == 0 ]]; then
    BORDER="white"
else 
    BORDER="black"
fi

convert -background blue -font 'Noto-Sans-Black' -pointsize 1500 \
    -fill orangered label:$NUMBER \
    -trim +repage -resize 700x700! \
    -bordercolor $BORDER -border 100x100 \
    number.png
echo "$NUMBER $BORDER"
$tweet_script post -i number.png "$NUMBER"
rm number.png
popd
