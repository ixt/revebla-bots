#!/bin/bash
text="$2"
    tweetLink="$1"
    echo ${tweetLink}
    tweetId=$(cut -d/ -f6 <<<"$tweetLink") 
while ! [[ -a "/home/orange/jeffree/${tweetId}.png" ]]; do
    adb connect orange-shots.lan
    adb shell am start -a android.intent.action.VIEW -d $tweetLink
    sleep 3s
    adb shell screencap -p /sdcard/${tweetId}.png
    adb pull /sdcard/${tweetId}.png /home/orange/jeffree/${tweetId}.png
done

/home/orange/Pkgs/discord.sh/discord.sh --webhook-url "${discordWebhookUrl}" --file /home/orange/jeffree/${tweetId}.png --text "$text"
# convert /home/orange/jeffree/${tweetId}.png -level 30%,100% -colorspace gray -rotate 180 - | lpr
