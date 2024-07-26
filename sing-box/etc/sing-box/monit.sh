#!/bin/sh

# Function to check if sing-box is running
is_sing_box_running() {
    pgrep -f "/usr/bin/sing-box run -D /etc/sing-box/ -c ./config.json" > /dev/null
    return $?
}

# Function to check internet connectivity with timeout (5 seconds)
check_internet_connection() {
    curl -s -o /dev/null -w "%{http_code}" --head --connect-timeout 5 https://cp.cloudflare.com/generate_204 | grep -q "204"
    return $?
}

# Function to check if firewall4 has table "sing-box" (unchanged)
check_firewall_table() {
    nft list tables | grep "sing-box" > /dev/null
    return $?
}

# Function to restart sing-box (with logging and restart limiting)
restart_sing_box() {
    /etc/init.d/sing-box stop
    /usr/bin/jam.sh  # Assuming this script updates the configuration
    /etc/init.d/sing-box start
}

# Main monitoring logic
main() {
    # Check internet connection multiple times
    INTERNET_CHECK_RETRIES=5
    for i in $(seq 1 $INTERNET_CHECK_RETRIES); do
        if check_internet_connection; then
            break  # Internet is up, no need to continue checking
        elif [ $i -eq $INTERNET_CHECK_RETRIES ]; then
            # All retries failed, internet is down
            restart_sing_box
            logger -t "sing-box-monitor" "Sing-box Internet connection down. Restarting..."
            return  # Exit main after restarting
        fi
        sleep 1  # Wait for 1 second before retrying
    done

    # Check if sing-box is running and if the firewall table exists
    if ! is_sing_box_running || ! check_firewall_table; then
        logger -t "sing-box-monitor" "Sing-box or firewall issue detected. Restarting..."
        restart_sing_box
    else
        logger -t "sing-box-monitor" "sing-box is running properly."
    fi
}

# Call the main function directly (no loop for crontab)
main
