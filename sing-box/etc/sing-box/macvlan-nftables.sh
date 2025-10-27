#!/bin/sh
# macvlan-safe TPROXY rules for OpenWrt + sing-box
# - Captures ALL IPv4/IPv6 TCP+UDP (incl. STUN/WebRTC) via TPROXY
# - Prevents DNS & WebRTC leaks
# - Actively blocks rogue IPv6 Router Advertisements and DHCPv6 replies

# --- Configuration ---
LAN_BRIDGE="br-lan"
TPROXY_PORT=10105
ROUTING_MARK=0x29A      # Must match sing-box route.default_mark (666)
PROXY_FWMARK=0x1
PROXY_ROUTE_TABLE=100
# --- End Configuration ---

# Get the MAC address of the LAN bridge to identify legitimate packets
BR_MAC=$(ip link show $LAN_BRIDGE | awk '/ether/ {print $2}')

# RFC1918/ULA/link-local + doc ranges (expanded) + your modem subnet
ReservedIP4='{ 0.0.0.0/8, 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 192.168.0.0/16, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 240.0.0.0/4, 255.255.255.255/32 }'
ReservedIP6='{ ::/128, ::1/128, ::ffff:0:0:0/96, 64:ff9b::/96, 100::/64, 2001::/32, 2001:20::/28, 2001:db8::/32, 2002::/16, fc00::/7, fe80::/10, ff00::/8 }'
# Bypass local LAN + modem mgmt subnet (edit if your LAN differs)
CustomBypassIP='{ 192.168.0.0/16, 10.0.8.0/24 }'

clearFirewallRules() {
    ip -f inet  rule del fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE 2>/dev/null
    ip -f inet6 rule del fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE 2>/dev/null
    ip  route  del local 0.0.0.0/0 dev lo table $PROXY_ROUTE_TABLE 2>/dev/null
    ip -6 route del local ::/0      dev lo table $PROXY_ROUTE_TABLE 2>/dev/null
    # Delete our specific tables to avoid breaking firewall4.
    nft delete table inet sing-box 2>/dev/null
    nft delete table bridge singbox_ra_guard 2>/dev/null
    # /etc/init.d/firewall restart
    sleep 2
}

ensurePolicyRouting() {
    ip -f inet  rule show | grep -q "fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE" \
      || ip -f inet  rule add fwmark $PROXY_FWMARK table $PROXY_ROUTE_TABLE prio 100
    ip -f inet6 rule show | grep -q "fwmark $PROXY_FWMARK lookup $PROXY_ROUTE_TABLE" \
      || ip -f inet6 rule add fwmark $PROXY_FWMARK table $PROXY_ROUTE_TABLE prio 100

    ip  route add local 0.0.0.0/0 dev lo table $PROXY_ROUTE_TABLE 2>/dev/null || true
    ip -6 route add local ::/0      dev lo table $PROXY_ROUTE_TABLE 2>/dev/null || true
}

if [ "$1" = "set" ]; then
    ensurePolicyRouting

    if [ -z "$BR_MAC" ]; then
        echo "ERROR: Could not determine MAC address for $LAN_BRIDGE. Exiting."
        exit 1
    fi

    nft -f - <<EOF
table inet sing-box {
    chain prerouting_tproxy {
        type filter hook prerouting priority mangle; policy accept;

        # socket transparent for sing-box outbound connections
        # meta l4proto tcp socket transparent 1 meta mark set $PROXY_FWMARK accept

        # Avoid loops from traffic already marked by sing-box
        # meta mark $ROUTING_MARK return

        # Bypass local traffic
        fib daddr type local meta l4proto { tcp, udp } th dport $TPROXY_PORT reject with icmpx type host-unreachable
        fib daddr type local return

        # Bypass LAN + modem and reserved ranges
        ip  daddr $CustomBypassIP return
        ip  daddr $ReservedIP4    return
        ip6 daddr $ReservedIP6    return

        # DNS hijack to sing-box (both TCP+UDP)
        meta l4proto {tcp, udp} th dport 53 tproxy to :$TPROXY_PORT meta mark set $PROXY_FWMARK

        # Transparent proxy for everything else (TCP + UDP, IPv4 + IPv6)
        meta l4proto {tcp, udp} tproxy ip  to :$TPROXY_PORT meta mark set $PROXY_FWMARK
        meta l4proto {tcp, udp} tproxy ip6 to :$TPROXY_PORT meta mark set $PROXY_FWMARK
    }

    chain output_tproxy {
        type route hook output priority mangle; policy accept;

        # meta mark $ROUTING_MARK return
        oifname "lo" return

        # Bypass modem/LAN and reserved ranges
        ip  daddr $CustomBypassIP return
        ip  daddr $ReservedIP4    return
        ip6 daddr $ReservedIP6    return

        # Force DNS from router itself into TPROXY as well
        meta l4proto {tcp, udp} th dport 53 meta mark set $PROXY_FWMARK return

        meta l4proto {tcp, udp} meta mark set $PROXY_FWMARK
    }
}

table bridge singbox_ra_guard {
    chain ra_guard {
        type filter hook prerouting priority -300; policy accept;
        iifname "${LAN_BRIDGE}" ip6 nexthdr udp udp sport 547 udp dport 546 drop
        iifname "${LAN_BRIDGE}" ip6 nexthdr icmpv6 icmpv6 type 134 drop
    }
}
EOF
    echo "sing-box nftables rules installed"

elif [ "$1" = "clear" ]; then
    clearFirewallRules
    echo "sing-box nftables rules cleared"
else
    echo "Usage: $0 {set|clear}"
    exit 1
fi
