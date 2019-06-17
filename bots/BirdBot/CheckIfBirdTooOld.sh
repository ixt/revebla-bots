#!/bin/bash
LASTTWEETSTAMP=$(t timeline birdbot4 -n 1 -c | cut -d, -f 2 | sed -n 2p | xargs -I@ date --date="@" +%s)
CURRENTSTAMP=$(date +%s)
TIMESINCE=$(bc -l <<<"$CURRENTSTAMP - $LASTTWEETSTAMP")
if [[ "$DEBUG" == "1" ]]; then
    echo last tweet $LASTTWEETSTAMP
    echo current time $CURRENTSTAMP
    echo time between $TIMESINCE
fi
if [[ "$TIMESINCE" -gt "1800" ]]; then
    [[ "$DEBUG" ]] && echo too old
	exit 1
else
    [[ "$DEBUG" ]] && echo its fine!
	exit 0
fi
