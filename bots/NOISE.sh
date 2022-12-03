#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# Nothing interesting just noise, currently broken as the full array is not
# tweeted
# "_" "▖" "▗" "▄" "▘" "▌" "▚" "▙" "▝" "▞" "▐" "▟" "▀" "▛" "▜" "█" )
# ▛▀▀▌▘▙▘▛▀▀▌
# ▌█▌▌█▝ ▌█▌▌
# ▌▀▘▌▚▟▘▌▀▘▌
# ▀▀▀▘▘▘▌▀▀▀▘
# ▀▛▗▚▀▜▛▄█▙▌
CHARS=( "_" "▖" "▗" "▄" "▘" "▌" "▚" "▙" "▝" "▞" "▐" "▟" "▀" "▛" "▜" "█" )
SCRIPTDIR=$(dirname $0)
pushd $SCRIPTDIR 
source ../BotADay.sh
LINE=("" "" "" "" "" "" "" "" "" "" "" "" "")
for x in $(seq 0 12); do
    for i in $(seq 0 12); do
        LINE[$x]="${LINE[$x]}${CHARS[$(( $RANDOM % ${#CHARS[@]} ))]}"
    done
done
echo "${LINE[0]}
${LINE[1]}
${LINE[2]}
${LINE[3]}
${LINE[4]}
${LINE[6]}
${LINE[7]}
${LINE[8]}
${LINE[9]}
${LINE[12]}" | $tweet_script post | jq . 
popd
