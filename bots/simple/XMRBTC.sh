#!/bin/bash
# https://twitter.com/TwoBitPirate/status/976463377001312256
# A bot that tweets the current exchange rate for 1 XMR in BTC
CURRENT=$(curl -X GET "https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=btc" -H  "accept: application/json" | jq -r .monero.btc)
t update "A \$XMR is worth $CURRENT BTC" -P ~/.trc.monero
