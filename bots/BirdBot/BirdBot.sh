#!/bin/bash
pushd $(dirname $0)
. ../../BotADay.sh
too_good_to_fail "./Birds.sh" "./CheckIfBirdTooOld.sh"
popd 
