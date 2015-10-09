#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

wifi="i-HDU"
device="en0"
sleep=0
title="${wifi} Wi-Fi Auto Login"

notification() {
	$DIR/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "${title}" -subtitle "" -message "${1}" -appIcon "${DIR}/icon.png" -sound default 2>/dev/null
	echo ${1}
}

echo -n "Checking Wi-fi device status..."
devicestatus=$(networksetup -getairportpower en0 | cut -f 4 -d " ")
echo $devicestatus

if [ "$devicestatus" != "On" ]
then
	notification "Powering on Wi-Fi $device..."
	networksetup -setairportpower $device on
	sleep $sleep
fi	

# Check if connected to i-HDU
echo -n "Checking which Wi-Fi AP is connected..."
current=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
echo $current

if [ "$current" == "$wifi" ]
then
	echo “Wi-Fi $wifi already connected. Logging in...”
else
	# Find if there is i-HDU
	notification "Searching for Wi-Fi $wifi..."
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport scan | grep $wifi
	if [ "$?" == "0" ]
	then
		notification "Connecting to Wi-Fi $wifi..."
		networksetup -setairportnetwork en0 $wifi
		# Check if connected to i-HDU
		echo -n "Checking which Wi-Fi AP is connected..."
		current=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
		echo $current
		if [ "$current" != "$wifi" ]
		then
			notification "Error: Failed to connect to $wifi. "
			exit 7
		fi
	else
		notification "Error: Wi-Fi $wifi not found. "
		exit 5
	fi
fi

# Checking if Python3 is installed
echo -n "Searching for python3..."
which python3
if [ "$?" != "0" ]
then
	notification "Error: You don't have Python 3 installed, auto login disabled. "
	exit 6
fi

notification "Logging in..."
/usr/bin/env python3 $DIR/login_script/login