#!/bin/sh

INTERFACE=$(ip route show default | awk '/default/ {print $5}')
TPROXY_PORT=10105
ROUTING_MARK=0x29A    # Ensure this matches the mark set by your proxy software
PROXY_FWMARK=0x1
PROXY_ROUTE_TABLE=100

# Reserved IP addresses (OpenWrt specific)
ReservedIP4='{ 0.0.0.0/8, 10.0.0.0/8, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 192.168.0.0/16, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 240.0.0.0/4, 255.255.255.255/32 }'
ReservedIP6='{ ::/128, ::1/128, ::ffff:0:0:0/96, 64:ff9b::/96, 100::/64, 2001::/32, 2001:20::/28, 2001:db8::/32, 2002::/16, fc00::/7, fe80::/10, ff00::/8 }'
CustomBypassIP='{ 192.168.0.0/16, 10.0.8.0/24 }'

# Function to clear firewall rules and handle errors
clearFirewallRules() {
    ip -f inet rule del fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE || { echo "Delete rule mark ipv4"; }
    ip -f inet6 rule del fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE || { echo "Delete rule mark ipv6"; }

    ip route del local 0.0.0.0/0 dev lo table $PROXY_ROUTE_TABLE || { echo "Delete route ipv4"; }
    ip -6 route del local ::/0 dev lo table $PROXY_ROUTE_TABLE || { echo "Delete route ipv6"; }
    nft flush ruleset >/dev/null 2>&1  # Redirect output to avoid clutter
    /etc/init.d/firewall restart       # Restart firewall service
    sleep 3                            # Give firewall time to restart
}

if [ "$1" = "set" ]; then
    # Routing IPv4 rules for OpenWrt - with checks and handling for existing routes
    if ! ip -f inet rule show | grep -q "fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE"; then
        ip -f inet rule add fwmark $PROXY_FWMARK table $PROXY_ROUTE_TABLE prio 5000 || { echo "Error setting routing rule IPv4. Exiting."; }
    else
        echo "Routing rule already exists."  # Inform the user
    fi

    ip route add local 0.0.0.0/0 dev lo table $PROXY_ROUTE_TABLE || { echo "Error setting local route IPv4. Exiting."; }

    # Routing IPv6 rules for OpenWrt - with checks and handling for existing routes
    if ! ip -f inet6 rule show | grep -q "fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE"; then
        ip -f inet6 rule add fwmark $PROXY_FWMARK table $PROXY_ROUTE_TABLE prio 5000 || { echo "Error setting routing rule IPv6. Exiting."; }
    else
        echo "Routing rule already exists."  # Inform the user
    fi

    ip -6 route add local ::/0 dev lo table $PROXY_ROUTE_TABLE || { echo "Error setting local route IPv6. Exiting."; }

    nft -f - <<EOF
table inet sing-box {
    chain prerouting_tproxy {
        type filter hook prerouting priority mangle; policy accept;
        # DNS & Custom Bypass
        meta l4proto {tcp, udp} th dport 53 tproxy to :$TPROXY_PORT return
        ip daddr $CustomBypassIP return

        # Local & Reserved IP Bypass
        fib daddr type local meta l4proto { tcp, udp } th dport $TPROXY_PORT reject with icmpx type host-unreachable
        fib daddr type local return
        ip daddr $ReservedIP4 return
        ip6 daddr $ReservedIP6 return
        meta mark $ROUTING_MARK return

        # Handle established transparent proxy connections
        meta l4proto tcp socket transparent 1 meta mark set $PROXY_FWMARK accept

        # Mark other traffic for TPROXY
        # IPv4 TPROXY rule
        meta l4proto {tcp, udp} tproxy ip to :$TPROXY_PORT meta mark set $PROXY_FWMARK
        # IPv6 TPROXY rule (assuming your proxy listens on both IPv4 and IPv6)
        meta l4proto {tcp, udp} tproxy ip6 to :$TPROXY_PORT meta mark set $PROXY_FWMARK
    }

    chain output_tproxy {
        type route hook output priority mangle; policy accept;

        # Loopback & Marked Traffic Bypass
        oifname != $INTERFACE return
        meta mark $ROUTING_MARK return

        # DNS Redirection & Other Bypass
        meta l4proto {tcp, udp} th dport 53 meta mark set $PROXY_FWMARK return
        udp dport {netbios-ns, netbios-dgm, netbios-ssn} return
        ip daddr $CustomBypassIP return

        # Local & Reserved IP Bypass
        fib daddr type local return
        ip daddr $ReservedIP4 return
        ip6 daddr $ReservedIP6 return

        # Remaining Traffic Handling
        meta l4proto {tcp, udp} meta mark set $PROXY_FWMARK
    }

    chain forward_tproxy {
        type filter hook forward priority filter; policy accept;

        # Bypass LAN & modem gateway traffic (replace with your actual subnets)
        ip saddr $CustomBypassIP return

        # Mark traffic for proxy
        meta l4proto { tcp, udp } mark set $PROXY_FWMARK
    }
}
EOF
    echo "set nftables"

elif [ "$1" = "clear" ]; then
    clearFirewallRules
else
    echo "Invalid argument. Use 'set' or 'clear'."
    exit 1
fi