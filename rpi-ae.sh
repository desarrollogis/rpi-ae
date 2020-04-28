#!/usr/bin/env bash

pgrep fbcp || (sudo fbcp &)
READLINK=$(which greadlink)
[ "$READLINK" == "" ] && READLINK=$(which readlink)
SCRIPTPATH=$("$READLINK" -f "${BASH_SOURCE[0]}")
SCRIPTNAME=$(basename "$SCRIPTPATH")
SCRIPTDIR=$(dirname "$SCRIPTPATH")
previous=
if [ "$previous" == "" ]
then
	for i in $(ls -1 "$SCRIPTDIR/commands/")
	do
		previous="$i"
		break
	done
fi
process=0
while true
do
	for i in $(ls -1 "$SCRIPTDIR/commands/")
	do
		if [ "$process" == "0" ]
		then
			if [ "$i" == "$previous" ]
			then
				process=1
			fi
		fi
		if [ "$process" == "1" ]
		then
			[ -f "$SCRIPTDIR/commands/$i/title" ] && (cat "$SCRIPTDIR/commands/$i/title" | figlet) || (echo "$i" | figlet)
			read -n3 key
			if [ "$key" == "" ]
			then
				[ -f "$SCRIPTDIR/commands/$i/do" ] && bash "$SCRIPTDIR/commands/$i/do" || "$i"
				exit
			fi
		fi
	done
done
