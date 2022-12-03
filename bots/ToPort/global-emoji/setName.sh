#!/bin/bash
# t set name "VALUE" --profile="/home/orange/.trc.globalemoji"
case $((($(date +%H) * 3) / 24)) in
    0)
        t set name "🌎🌍🌏" --profile="/home/orange/.trc.globalemoji"
        ;;
    1) 
        t set name "🌍🌏🌎" --profile="/home/orange/.trc.globalemoji"
        ;;
    2) 
        t set name "🌏🌎🌍" --profile="/home/orange/.trc.globalemoji"
        ;;
    3) 
        t set name "🌏🌎🌍" --profile="/home/orange/.trc.globalemoji"
        ;;
    *) 
        echo "error"
        ;;
esac
