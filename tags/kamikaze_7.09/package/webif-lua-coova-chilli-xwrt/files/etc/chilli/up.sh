#!/bin/sh
# Coova Chilli - David Bird <david@coova.com>
# Licensed under the GPL, see http://coova.org/
# up.sh /dev/tun0 192.168.0.10 255.255.255.0

. /etc/chilli/functions

[ -e "/var/run/chilli.iptables" ] && sh /var/run/chilli.iptables 2>/dev/null
rm -f /var/run/chilli.iptables 2>/dev/null

IF=$(basename $DEV)

ipt() {
    opt=$1; shift
    echo "iptables -D $*" >> /var/run/chilli.iptables
    iptables $opt $*
}

ipt_in() {
    ipt -A INPUT -i $IF $*
}

[ -n "$DHCPIF" ] && {

    [ -n "$UAMPORT" -a "$UAMPORT" != "0" ] && \
	ipt_in -p tcp -m tcp --dport $UAMPORT --dst $ADDR -j ACCEPT

    [ -n "$UAMUIPORT" -a "$UAMUIPORT" != "0" ] && \
	ipt_in -p tcp -m tcp --dport $UAMUIPORT --dst $ADDR -j ACCEPT

    [ -n "HS_TCP_PORTS" ] && {
	for port in $HS_TCP_PORTS; do
	    ipt_in -p tcp -m tcp --dport $port --dst $ADDR -j ACCEPT
	done
    }
    
    ipt_in -p udp -d 255.255.255.255 --destination-port 67:68 -j ACCEPT
    ipt_in -p udp --dst $ADDR --dport 53 -j ACCEPT

#    ipt -A INPUT -i $IF --dst $ADDR -j DROP
#    ipt -A INPUT -i $IF -j DROP

#    ipt -I FORWARD -i $DHCPIF -j DROP
#    ipt -I FORWARD -o $DHCPIF -j DROP
    ipt -I FORWARD -i $IF -j ACCEPT
    ipt -I FORWARD -o $IF -j ACCEPT

    [ "$HS_LAN_ACCESS" != "on" -a "$HS_LAN_ACCESS" != "allow" ] && \
#	ipt -I FORWARD -i $IF -o \! $HS_WANIF -j DROP

    [ "$HS_LOCAL_DNS" = "on" ] && \
	ipt -I PREROUTING -t nat -i $IF -p udp --dport 53 -j DNAT --to-destination $ADDR
}

# site specific stuff optional
[ -e /etc/chilli/ipup.sh ] && . /etc/chilli/ipup.sh
