#!/bin/sh

cd /

echo "Boot successful."

MESSAGE="Rebooting"	# REBOOT_MESSAGE
COMMAND="reboot"	# REBOOT_COMMAND

grep "noreboot" /proc/cmdline >/dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "${MESSAGE}"
	${COMMAND}
	sleep 2
fi

exec /bin/sh
