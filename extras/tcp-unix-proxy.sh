#!/usr/bin/env bash

set -eu

if [ $# -ne 2 ]; then
	echo 'usage: $0 TCP_HOST:TCP_PORT SOCKET_FILE'
	exit 1
fi

tcp_address=$1
socket_file=$2

socat unix-listen:${socket_file},fork,reuseaddr "exec:'socat tcp-connect:${tcp_address} stdio',nofork"
