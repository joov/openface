#!/bin/bash
#until ping -c1 openface >/dev/null; do
#	echo "Waiting for openface" 
#	sleep 1
#donea
echo "Waiting for openface"
sleep 15s
nginx -g "daemon off;"

