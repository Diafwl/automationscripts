HOST_IPADDR=${2}
HOST_PORT=${3}
GUEST_IPADDR=${4}
GUEST_PORT=${5}
PROTOCOL=${6}

if [ -z $PROTOCOL ]; then
        echo "_1:add/del,2:host_ip,3:host_port,4:guest_ip,5:guest_port,6:tcp/udp"

elif [ "${1}" = "add" ]; then
        iptables -t nat -A PREROUTING -d "$HOST_IPADDR/32" -p $PROTOCOL --dport "$HOST_PORT" -j DNAT --to "$GUEST_IPADDR:$GUEST_PORT"
        iptables -I FORWARD -d "$GUEST_IPADDR/32" -p $PROTOCOL -m state --state NEW -m $PROTOCOL --dport "$GUEST_PORT" -j ACCEPT
        echo "$2:${3} forwarded to ${4}:${5} ${6}"
elif [ "${1}" = "del" ]; then
        iptables -t nat -D PREROUTING -d "$HOST_IPADDR/32" -p $PROTOCOL --dport "$HOST_PORT" -j DNAT --to "$GUEST_IPADDR:$GUEST_PORT"
        iptables -D FORWARD -d "$GUEST_IPADDR/32" -p $PROTOCOL -m state --state NEW -m $PROTOCOL --dport "$GUEST_PORT" -j ACCEPT
        echo "deleted :${2} forward to ${3}:${4}"
else
    	echo "1:add/del,2:host_ip,3:host_port,4:guest_ip,5:guest_port,6:tcp/udp"
fi
