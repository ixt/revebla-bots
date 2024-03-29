#!/bin/bash
#
#   ChildTraffking.sh - Tracks recently sold cyberkidz nfts and tweets them out
# 
temp=$(mktemp)
SCRIPTDIR=$(dirname $0)
pushd $SCRIPTDIR 
. ../../BotADay.sh
source_trc ~/.trc.cyber
pushd npm &>/dev/null
node app.js > $temp
popd &>/dev/null
fullresults=""
while read line; do
    fullresults+=$(printf "$line")
done < $temp
echo $fullresults > $temp

while IFS=, read -a kid; do
    if [ "${kid[0]}" != "" ]; then
        id=$(echo ${kid[0]} | sed -e "s/.*\#\([0-9]*\).*/\1/g")
        price=$(echo ${kid[@]} | sed 's/[^0-9. ]* ꜩ.*//g' | sed -e "s/.* //g")
        message="CyberKid #${id} just sold for $price ꜩ" 
        hashes=$(sha256sum <<<"$message")

        if ! grep -q "$message" messages.txt; then
            echo "$message" | tee -a messages.txt
            echo "$message https://objkt.com/asset/cyberkidzclub/${id}" | $tweet_script post 
        else
            echo "seen $message"
        fi
    fi
done < <(sed -e "s/@: /\n/g;s/CyberKidz Club1xCyberKidz Club //g;s/tz1Z5...x7dRAfor /,/g" $temp \
    | sed -e "s/ꜩ.*/ꜩ/g")

if [[ $(wc -l < messages.txt) -gt 56 ]]; then
    echo "cutting"
    tail -n 28 messages.txt > $temp
    cp $temp messages.txt
fi

# Beyond the Dome
pushd npm &>/dev/null
node app2.js > $temp
popd &>/dev/null
fullresults=""
while read line; do
    fullresults+=$(printf "$line")
done < $temp
echo $fullresults > $temp

while IFS=, read -a kid; do
    if [ "${kid[0]}" != "" ]; then
        id=$(echo ${kid[0]} | sed -e "s/.*\#\([0-9]*\).*/\1/g")
        price=$(echo ${kid[@]} | sed 's/[^0-9. ]* ꜩ.*//g' | sed -e "s/.* //g")
        message="Beyond the Dome #${id} just sold for $price ꜩ" 
        hashes=$(sha256sum <<<"$message")

        if ! grep -q "$message" messages2.txt; then
            echo "$message" | tee -a messages2.txt
            echo "$message https://objkt.com/asset/cyberkidzclub_btd/${id}" | $tweet_script post 
        else
            echo "seen $message"
        fi
    fi
done < <(sed -e "s/@: /\n/g;s/CyberKidz Club1xCyberKidz Club //g;s/tz1Z5...x7dRAfor /,/g" $temp \
    | sed -e "s/ꜩ.*/ꜩ/g")

if [[ $(wc -l < messages2.txt) -gt 56 ]]; then
    echo "cutting"
    tail -n 28 messages2.txt > $temp
    cp $temp messages2.txt
fi

rm $temp
popd
