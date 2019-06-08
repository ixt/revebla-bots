#!/bin/bash
pushd $(dirname $0)
. ../../BotADay.sh

too_good_to_fail ./CheckIfBirdTooOld.sh ./Birds.sh
popd 
