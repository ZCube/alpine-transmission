#!/bin/sh

set -e
SETTINGS=/etc/transmission-daemon/settings.json

if [[ ! -f ${SETTINGS}.bak ]]; then
	# Checks for USERNAME variable
	if [ -z "$USERNAME" ]; then
	  echo >&2 'Please set an USERNAME variable (ie.: -e USERNAME=john).'
	  exit 1
	fi
	# Checks for PASSWORD variable
	if [ -z "$PASSWORD" ]; then
	  echo >&2 'Please set a PASSWORD variable (ie.: -e PASSWORD=hackme).'
	  exit 1
	fi
	# Modify settings.json
	sed -i.bak -e "s/#rpc-password#/$PASSWORD/" $SETTINGS
	sed -i.bak -e "s/#rpc-username#/$USERNAME/" $SETTINGS
fi

if [ -z "$INCOMPLETE_FS" ]; then
  echo >&2 'Please set a INCOMPLETE_FS variable (ie.: -e INCOMPLETE_FS=fs or ramfs or tmpfs).'
  exit 1
fi

if [ "$INCOMPLETE_FS" == "fs" ]; then
   umount /transmission/incomplete
elif [ "$INCOMPLETE_FS" == "ramfs" ]; then
  if [ -z "$INCOMPLETE_SIZE" ]; then
    mount -t ramfs -o ramfs /transmission/incomplete
  else
    mount -t ramfs -o size=$INCOMPLETE_SIZE ramfs /transmission/incomplete
  fi
elif [ "$INCOMPLETE_FS" == "tmpfs" ]; then
  if [ -z "$INCOMPLETE_SIZE" ]; then
    mount -t tmpfs -o tmpfs /transmission/incomplete
  else
    mount -t tmpfs -o size=$INCOMPLETE_SIZE tmpfs /transmission/incomplete
  fi
else
fi

unset PASSWORD USERNAME

exec /usr/bin/transmission-daemon --foreground --config-dir /etc/transmission-daemon
