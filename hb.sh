#!/bin/bash
# A simple heartbeat script.
# You can replace this with a real curl command to a service.

while true
do
  echo "CURLNODE-HB is alive at $(date)"
  sleep 10
done
