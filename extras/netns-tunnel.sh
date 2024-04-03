#!/usr/bin/env bash

set -eu

if [ $# -ne 3 ]; then
	echo "usage: $0 NETNS_NAME NETNS_PORT TCP_HOST:TCP_PORT"
	exit 1
fi

netns_name=$1
netns_port=$2
tcp_address=$3

socket_file=/tmp/socat.$RANDOM.tmp.sock

pids=()

sudo ./netns-unix-proxy.sh wg "${netns_port}" ${socket_file} &
pids+=($!)
sudo ./tcp-unix-proxy.sh "${tcp_address}" "${socket_file}" &
pids+=($!)

for pid in "${pids[@]}"; do
  echo $pid
  if wait -n; then
    :
  else
    exit_code=$?
    echo "Process exited with $exit_code, killing other tests now."
    for pid in "${pids[@]}"; do
      kill -9 "$pid" 2> /dev/null || :
    done
    exit "$exit_code"
  fi
done
