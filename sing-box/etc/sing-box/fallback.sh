#!/bin/sh

BASE_URL="http://192.168.1.1:9090"
YOUR_TOKEN=""
AUTH_HEADER="Authorization: Bearer $YOUR_TOKEN"
INTERVAL=300
LOG_FILE="/tmp/proxy_change.log"
CONFIG_FILE="/etc/sing-box/config.json"

get_proxies() {
    curl -s -X GET -H "$AUTH_HEADER" "$BASE_URL/proxies/$1"
}

get_delay() {
    proxy_name=$1
    url_encoded="https%3A%2F%2Fwww.youtube.com%2Fgenerate_204"
    response=$(curl -s -X GET -H "$AUTH_HEADER" "$BASE_URL/proxies/$proxy_name/delay?url=$url_encoded&timeout=5000")
    delay=$(echo "$response" | jq -r '.delay // 5000')
    echo $delay
}

log_change() {
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    if [ "$2" = "(unchanged)" ]; then
        echo "$timestamp - $1 $2: $3 with delay $4 ms" >> "$LOG_FILE"
    elif [ "$2" = "(all proxies failed)" ]; then
        echo "$timestamp - $1 $2" >> "$LOG_FILE"
    else
        echo "$timestamp - $1 changed from $2 to $3 with delay $4 ms" >> "$LOG_FILE"
    fi
}

set_proxy() {
    group_name=$1
    proxy_name=$2
    current_proxy=$3
    delay=$4

    # Build JSON data properly
    json_data='{"name":"'"$proxy_name"'"}'
    # Make the API call
    response=$(curl -s -w "\n%{http_code}" -X PUT -H "$AUTH_HEADER" -H "Content-Type: application/json" -d "$json_data" "$BASE_URL/proxies/$group_name")

    # Check the HTTP status code
    status_code=$(echo "$response" | tail -n1)
    if [ "$status_code" != "204" ]; then
        echo "Failed to set proxy for $group_name (HTTP $status_code):"
        echo "$response" | head -n -1
        exit 1  # Optional: Exit the script if the proxy change fails
    else
        log_change "$group_name" "$current_proxy" "$proxy_name" "$delay"
    fi
}

change_proxy_group() {
    group_name=$1
    group=$(get_proxies "$group_name")
    current_proxy=$(echo "$group" | jq -r '.now')

    priorities=$(jq -r '[.outbounds[] | select(.type == "selector" and .tag == "'"$group_name"'") | .outbounds[] | select(. != "DIRECT")] | join(" ")' "$CONFIG_FILE")

    # Prioritize the first proxy in the list
    first_proxy=$(echo "$priorities" | awk '{print $1}')
    first_proxy_delay=$(get_delay "$first_proxy")

    if [ "$first_proxy_delay" -lt 5000 ]; then  # If the first proxy is okay
        if [ "$current_proxy" != "$first_proxy" ]; then
            # Switch to the first proxy if it's not the current one
            set_proxy "$group_name" "$first_proxy" "$current_proxy" "$first_proxy_delay"
            return
        else
            # Log unchanged status if the first proxy is already active
            log_change "$group_name" "(unchanged)" "$first_proxy" "$first_proxy_delay"
        fi
    else
        # If the first proxy is down, find a better one
        for proxy in $priorities; do
            delay=$(get_delay "$proxy")
            if [ "$delay" -lt 5000 ] && [ "$((delay - first_proxy_delay))" -lt -200 ] && [ "$proxy" != "$current_proxy" ]; then
                set_proxy "$group_name" "$proxy" "$current_proxy" "$delay"
                return
            fi
        done

        # Log if all proxies failed
        log_change "$group_name" "(all proxies failed)" "-" "-"
    fi
}

change_selection_p0rn() {
    group=$(get_proxies "Selection%20P0rn")
    current_proxy=$(echo "$group" | jq -r '.now')
    if [ "$current_proxy" = "block-out" ]; then
        set_proxy "Selection%20P0rn" "Internet" "$current_proxy" 0
    fi
}

check_service_running() {
    if pgrep -f "/usr/bin/sing-box run -D /etc/sing-box/ -c ./config.json" > /dev/null; then
        return 0
    else
        return 1
    fi
}

main() {
    if check_service_running; then
        change_proxy_group "Internet"
        change_proxy_group "Region"
        change_proxy_group "GAME"
        change_selection_p0rn
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Service is not running, skipping this interval." >> $LOG_FILE
    fi
}

while true; do
    main
    sleep $INTERVAL
done