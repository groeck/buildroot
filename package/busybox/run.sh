#!/bin/sh

cd /

cat /proc/version

network_test()
{
    local ip_test_passed=0

    # wait for a few seconds until the Ethernet interface is up,
    # but only if it exists
    if [ -e /sys/class/net/eth0 ]; then
	retries=0
	while [ ${retries} -lt 5 ]; do
	    ifconfig eth0 2>/dev/null | grep -q "inet addr:10.0.2.15"
	    if [ $? -eq 0 ]; then
		ip_test_passed=1
		break
	    fi
	    retries=$((retries + 1))
	    sleep 1
	done
    fi

    if [ ${ip_test_passed} -ne 0 ]; then
	ping -q -c 1 -s 1000 -W 1 -I eth0 10.0.2.2 >/dev/null
	if [ $? -eq 0 ]; then
	    telnet 10.0.2.2:22 </dev/null >/dev/null 2>dev/null
	    if [ $? -eq 0 ]; then
		echo "Network interface test passed"
		return 0
	    fi
	fi
    fi

    echo "Network interface test failed"
    return 1
}

tpm_test()
{
    if [ -c /dev/tpm0 ]; then
	if [ "$(cat /sys/class/tpm/tpm0/tpm_version_major)" -eq 2 ]; then
	    tpm2_selftest -f
	    if [ $? -eq 0 ]; then
		echo "TPM selftest passed"
		return 0
	    fi
	fi
    fi
    echo "TPM selftest failed"
    return 1
}

network_test

tpm_test

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
