#!/bin/sh

TMPDIR=~/.local/bash_weather_get;

# SIGHUP
trap "" 1

if [ -f ${TMPDIR}/lock ]; then
	LAST_PID=`cat ${TMPDIR}/lock`
	ps -p ${LAST_PID} 1>/dev/null 2>/dev/null
	if [ $? -eq 0 ]; then
		if [ `tput cols` -gt 130 ]; then
			cat ${TMPDIR}/weather.txt
		else
			cat ${TMPDIR}/weather.txt | head -n 8
		fi
		exit
	else
		rm -rf /tmp/bash_weather_get
	fi
fi

mkdir -p ${TMPDIR} 2>/dev/null
echo "$$" > ${TMPDIR}/lock

while true; do
	WEATHER=`curl -s wttr.in`

	if [ $? -ne 0 ]; then
		echo "Weather: Network Error" > ${TMPDIR}/weather.txt
		WEATHER=`curl -s wttr.in`
		while [ $? -ne 0 ]; do
			sleep 10m
			WEATHER=`curl -s wttr.in`
		done
	fi

	DATE=`date '+%F %H:%M'`

	echo -e "Last update ${DATE}\n${WEATHER}" > ${TMPDIR}/weather.txt

	sleep 1h
done
