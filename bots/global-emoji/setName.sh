#!/bin/bash
# t set name "VALUE" 
# This script is no longer used, keeping for legacy reasons
case $((($(date +%H) * 3) / 24)) in
    0)
        t set name "🌎🌍🌏" 
        ;;
    1) 
        t set name "🌍🌏🌎"
        ;;
    2) 
        t set name "🌏🌎🌍" 
        ;;
    3) 
        t set name "🌏🌎🌍"
        ;;
    *) 
        echo "error"
        ;;
esac
