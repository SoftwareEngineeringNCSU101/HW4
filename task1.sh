#!/bin/bash

# Find the process ID (PID) of the running script
# pid=$(ps -ef | grep 'sleep 0'| grep -v 'grep'| awk '{print $2}')
pid=$(pgrep -f "infinite.sh")
#Check if PID exists  and kill the process
if [ -z "$pid" ]; then
	echo "No process found"
else
	kill $pid
	echo "Process with pid $pid has been killed"

fi
