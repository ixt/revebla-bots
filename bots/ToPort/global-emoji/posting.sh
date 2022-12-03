#!/bin/bash
# Remove all empty lines, pick top line and then post removing that line after

sed -i "/^$/d" $1
tweet=$(head -1 $1)
sed -i "/^$tweet$/d" $1
t update "$tweet" -P $2
