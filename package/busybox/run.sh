#!/bin/sh

cd /

cat /proc/version

net_test_successful=0
ifconfig eth0 2>/dev/null | grep -q "inet addr:10.0.2.15"
if [ $? -eq 0 ]; then
    ping -q -c 1 -s 1000 -W 1 -I eth0 10.0.2.2 >/dev/null
    if [ $? -eq 0 ]; then
	telnet 10.0.2.2:22 </dev/null >/dev/null 2>dev/null
	if [ $? -eq 0 ]; then
	    net_test_successful=1
	fi
    fi
fi

if [ ${net_test_successful} -ne 0 ]; then
    echo "Network interface test passed"
else
    echo "Network interface test failed"
fi

echo "Boot successful."

MESSAGE="Rebooting"	# REBOOT_MESSAGE
COMMAND="reboot"	# REBOOT_COMMAND

grep "noreboot" /proc/cmdline >/dev/null 2>&1
if [ $? -ne 0 ]
then
	sleep 1
	echo "${MESSAGE}"
	${COMMAND}
	sleep 15
	${COMMAND} -f
	sleep 2
fi

exec /bin/sh
