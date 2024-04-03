#!/usr/bin/env bash

set -eu

if [ $# -lt 3 ]; then
	echo 'usage: $0 NETNS_NAME NETNS_PORT SOCKET_FILE'
	exit 1
fi

netns_name=$1
netns_port=$2
socket_file=$3

#socket_file=/tmp/socat.$RANDOM.tmp.sock
ip netns exec ${netns_name} socat tcp-listen:${netns_port},reuseaddr,fork "exec:'socat unix-connect:${socket_file} stdio',nofork"
