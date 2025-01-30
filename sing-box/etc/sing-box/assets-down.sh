#!/bin/sh

check_internet_connection() {
    # Check if the internet is available via the proxy
    curl -s -x http://127.0.0.1:10808 -o /dev/null -w "%{http_code}" --head --connect-timeout 5 https://cp.cloudflare.com/generate_204 | grep -q "204"
    return $?
}

get_public_ip() {
    local ip_type=$1  # "ipv4" or "ipv6"
    local proxy_flag=""

    # If the proxy is available, set the proxy flag
    if check_internet_connection; then
        proxy_flag="-x http://127.0.0.1:10808"
    fi

    # Get the public IP address
    public_ip=$(curl -s $proxy_flag -4 http://www.cloudflare.com/cdn-cgi/trace | grep "ip" | awk -F "=" '{print $2}' | tr -d ' ')

    if [ "$ip_type" = "ipv6" ]; then
        public_ip=$(curl -s $proxy_flag -6 http://www.cloudflare.com/cdn-cgi/trace | grep "ip" | awk -F "=" '{print $2}' | tr -d ' ')
    fi

    echo "$public_ip"
}

check_ipaddress() {
    # Get public IPv4 address
    public_ipv4=$(get_public_ip "ipv4")
    if [ -z "$public_ipv4" ]; then
        echo "IPv4 Address: Not available"
    else
        echo "IPv4 Address: $public_ipv4"
    fi

    # Get public IPv6 address
    public_ipv6=$(get_public_ip "ipv6")
    if [ -z "$public_ipv6" ]; then
        echo "IPv6 Address: Not available"
    else
        echo "IPv6 Address: $public_ipv6"
    fi
}

# Function to download a file with retry logic
download_with_retry() {
    local url="$1"
    local output="$2"
    local retries=1  # Number of retry attempts
    local attempt=0

    # Attempt to download the file
    while [ $attempt -le $retries ]; do
        if curl -f -s -o "$output" $proxy_flag "$url"; then
            echo "Download successful: $output"
            return 0  # Success
        else
            attempt=$((attempt + 1))
            echo "Download failed: $output (Attempt $attempt)"
            if [ $attempt -le $retries ]; then
                echo "Retrying..."
                sleep 1  # Optional: wait before retrying
            fi
        fi
    done

    echo "Failed to download: $output, Make sure you have Internet Connection"
    return 1  # Failure
}

download_assets() {
    local proxy_flag=""

    # If the proxy is available, set the proxy flag
    if check_internet_connection; then
        proxy_flag="-x http://127.0.0.1:10808"
    fi

    # List of URLs and output paths
    declare -A assets=(
        ["https://cdn.jsdelivr.net/gh/IPTUNNELS/IPTUNNELS@main/sing-box/etc/sing-box/commonports.json"]="/etc/sing-box/commonports.json"
        ["https://cdn.jsdelivr.net/gh/malikshi/geoip@release/srs/facebook.srs"]="/etc/sing-box/geoip-facebook.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/geoip@release/srs/geoid.srs"]="/etc/sing-box/geoip-geoid.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/geoip@release/srs/id.srs"]="/etc/sing-box/geoip-id.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/geoip@release/srs/malicious.srs"]="/etc/sing-box/geoip-malicious.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-bank-id.srs"]="/etc/sing-box/geosite-bank-id.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-category-porn.srs"]="/etc/sing-box/geosite-category-porn.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-google-ads.srs"]="/etc/sing-box/geosite-google-ads.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-google.srs"]="/etc/sing-box/geosite-google.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-oisd-full.srs"]="/etc/sing-box/geosite-oisd-full.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-oisd-nsfw.srs"]="/etc/sing-box/geosite-oisd-nsfw.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-rule-doh.srs"]="/etc/sing-box/geosite-rule-doh.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-rule-indo.srs"]="/etc/sing-box/geosite-rule-indo.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-rule-malicious.srs"]="/etc/sing-box/geosite-rule-malicious.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-whatsapp.srs"]="/etc/sing-box/geosite-whatsapp.srs"
        ["https://cdn.jsdelivr.net/gh/malikshi/sing-box-geo@rule-set-geosite/geosite-youtube.srs"]="/etc/sing-box/geosite-youtube.srs"
    )

    # Download each asset
    for url in "${!assets[@]}"; do
        download_with_retry "$url" "${assets[$url]}"
    done
}

# Main function to check internet availability and get IP addresses
main() {
    clear
    if check_internet_connection; then
        echo "Internet is available through the proxy."
    else
        echo "Internet is NOT available through the proxy. Using direct connection."
    fi
    check_ipaddress
    download_assets
}

# Execute the main function
main