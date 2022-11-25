#!/bin/bash
# https://twitter.com/TwoBitPirate/status/976463377001312256
# A bot that tweets the current exchange rate for 1 XMR in BTC
TEMP=$(mktemp)
curl -X GET "https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=usd,eur,eth" -H  "accept: application/json" > $TEMP

USD=$(jq -r .tezos.usd $TEMP)
while [[ "${USD}" -eq "null" ]]; do
    sleep 1s
    
    curl -X GET "https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=usd,eur,eth" -H  "accept: application/json" > $TEMP
    USD=$(jq -r .tezos.usd $TEMP)
done

EUR=$(jq -r .tezos.eur $TEMP)
ETH=$(jq -r .tezos.eth $TEMP)
t update "1ꜩ Tezos Exchange Prices:
\$$USD USD
€$EUR Euro 
${ETH}ETH" -P ~/.trc-teztown
