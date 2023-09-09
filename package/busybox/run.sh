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

__fs_test()
{
    local rv=0
    local srcdirs="/bin /usr /sbin /etc /lib* /opt /var"

    if ! grep -q "fstest=" /proc/cmdline; then
	return 2
    fi

    local fstestdev=`cat /proc/cmdline | sed -e 's/.*fstest=//' | sed -e 's/ .*//'`

    if [ ! -b "${fstestdev}" ]; then
	return 1
    fi

    if ! mount "${fstestdev}" /mnt; then
	return 1
    fi

    local fstype=`lsblk -o FSTYPE -n "${fstestdev}"`

    # hfs and exfat do not support symlinks.
    if [ "${fstype}" = "hfs" -o "${fstype}" = "exfat" ]; then
	# The busybox version of cp always tries to copy symlinks,
	# so use tar to copy files if symlinks are not supported or
	# known to be broken.
	if ! tar cf /mnt/testfile.tar `find ${srcdirs} -type f` 2>/dev/null; then
	    rv=1
	fi
	cd /mnt
	if ! tar xf testfile.tar; then
	    rv=1
	fi
	if ! rm -rf bin; then
	    rv=1
	fi
	if ! tar xf testfile.tar --overwrite; then
	    rv=1
	fi
	cd /
    else
	if ! cp -a ${srcdirs} /mnt; then
	    rv=1
	fi
	if ! rm -rf /mnt/bin; then
	    rv=1
	fi
	if ! cp -a ${srcdirs} /mnt; then
	    rv=1
	fi
    fi

    if ! umount /mnt; then
	rv=1
    fi

    return ${rv}
}

fs_test()
{
    __fs_test
    case $? in
    0)
	echo "File system test passed"
	;;
    1)
	echo "File system test failed"
	;;
    *)
	echo "File system test skipped"
	;;
    esac
}

network_test

tpm_test

fs_test

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
