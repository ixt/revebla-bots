#!/bin/bash
# https://twitter.com/TehJoeCow/status/985642424784642048
# take a screen shot of the current 24h bitcoin chart, if up 300 usd then post
# saying the market is being manipulated, if it drops say the bubble is popping

checkPrice(){
    CURRENTPRICE=$(curl "https://blockchain.info/tobtc?currency=USD&value=1" \
        | xargs -I@ echo "scale=0; 1 / @ " \
        | bc -l )
}

width="500"
height="500"
SCRIPTDIR=$(dirname $0)
SCREENSHOT=$(mktemp --suffix=.png)
TEMP=$(mktemp)

pushd $SCRIPTDIR 

. ../BotADay.sh

[ ! -e ../data/bitcoinLastPrice ] && cp ../data/bitcoinOldPrice ../data/bitcoinLastPrice
read LASTPRICE < ../data/bitcoinLastPrice 
checkPrice

DIFFERENCE=$(bc -l <<< "scale=0; $LASTPRICE - $CURRENTPRICE" | cut -d. -f1)

echo "Diff $DIFFERENCE"
echo "L: $LASTPRICE"
echo "C: $CURRENTPRICE"
if [[ "$DIFFERENCE" -gt "300" || "$DIFFERENCE" -lt "-300" ]]; then
    screenshot "https://s.tradingview.com/widgetembed/?frameElementId=tradingview_07087&symbol=BITFINEX%3ABTCUSD&interval=1&hidesidetoolbar=0&symboledit=1&saveimage=1&toolbarbg=rgba(255,%20255,%20255,%201)&studies=MACD%40tv-basicstudies&theme=White&style=1&timezone=Etc%2FUTC&studies_overrides=%7B%7D&overrides=%7B%7D&enabled_features=%5B%5D&disabled_features=%5B%5D&locale=en&utm_source=bfxdata.com&utm_medium=widget&utm_campaign=chart&utm_term=BITFINEX%3ABTCUSD" "${SCREENSHOT}" "${width}" "${height}"

    cp $SCREENSHOT output.png
    if [[ "$DIFFERENCE" -gt "300" ]]; then
        echo "Change of +300"
        t update "More manipulation of the markets I see!" -f output.png -P ~/.trc.botfinexed
    else
        echo "Change of -300"
        t update "Looks like the bubble is finally bursting!" -f output.png -P ~/.trc.botfinexed
    fi
fi

echo "$CURRENTPRICE" > ../data/bitcoinLastPrice
rm output.png $SCREENSHOT $TEMP
popd
