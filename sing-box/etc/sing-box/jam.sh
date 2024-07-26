#!/bin/sh

# Default host
# Changes to your free access hostname/ipaddress
host="open.spotify.com"

# Process arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --host)
            host="$2"
            shift # past argument
            shift # past value
            ;;
        *)  # Unknown option
            echo "Unknown option: $key" >&2
            exit 1
            ;;
    esac
done

# Automatically Updates System Time
nistTime=$(curl -s -I --insecure "$host" | grep "ate:")
dateString=$(echo $nistTime | cut -d' ' -f2-7)
dayString=$(echo $nistTime | cut -d' ' -f2-2)
dateValue=$(echo $nistTime | cut -d' ' -f3-3)
monthValue=$(echo $nistTime | cut -d' ' -f4-4)
yearValue=$(echo $nistTime | cut -d' ' -f5-5)
timeValue=$(echo $nistTime | cut -d' ' -f6-6)
timeZoneValue=$(echo $nistTime | cut -d' ' -f7-7)

case $monthValue in
    Jan) monthValue="01";;
    Feb) monthValue="02";;
    Mar) monthValue="03";;
    Apr) monthValue="04";;
    May) monthValue="05";;
    Jun) monthValue="06";;
    Jul) monthValue="07";;
    Aug) monthValue="08";;
    Sep) monthValue="09";;
    Oct) monthValue="10";;
    Nov) monthValue="11";;
    Dec) monthValue="12";;
    *) continue
esac

ID=$(grep '^ID=' /etc/os-release)
OP='ID="openwrt"'
if [[ "$ID" == "$OP" ]]; then
    date --utc --set "${yearValue}-${monthValue}-${dateValue} ${timeValue}"
else
    date --utc --set "${yearValue}-${monthValue}-${dateValue}T${timeValue}Z"
fi
