HOST_PORT=${2}
GUEST_IPADDR=${3}
GUEST_PORT=${4}

if [ "${1}" = "add" ]; then
	iptables -t nat -A PREROUTING -p tcp --dport "$HOST_PORT" -j DNAT --to "$GUEST_IPADDR:$GUEST_PORT"
	iptables -I FORWARD -d "$GUEST_IPADDR/32" -p tcp -m state --state NEW -m tcp --dport "$GUEST_PORT" -j ACCEPT
	echo ":${2} forwarded to ${3}:${4}"
elif [ "${1}" = "del" ]; then
        iptables -t nat -D PREROUTING -p tcp --dport "$HOST_PORT" -j DNAT --to "$GUEST_IPADDR:$GUEST_PORT"
        iptables -D FORWARD -d "$GUEST_IPADDR/32" -p tcp -m state --state NEW -m tcp --dport "$GUEST_PORT" -j ACCEPT
	echo "deleted :${2} forward to ${3}:${4}"
else
	echo "1:add/del,2:host_port,3:guest_ip,4:guest_port"
fi
