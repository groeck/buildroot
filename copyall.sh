#!/bin/bash

copyone()
{
	local destdir="$(dirname /opt/buildbot/rootfs/$2)"
	local destfile="$(basename $2)"

	cp $1 "${destdir}/${destfile}"
	(cd "${destdir}"; md5sum "${destfile}" > "${destfile}.md5")
}

cd images

if [[ -d aarch64 ]]; then
    gzip -f -k aarch64/rootfs.btrfs
    copyone aarch64/rootfs.btrfs.gz arm64/rootfs.btrfs.gz
    copyone aarch64/rootfs.cpio.gz arm64/rootfs.cpio.gz
    copyone aarch64/rootfs.ext2.gz arm64/rootfs.ext2.gz
    copyone aarch64/rootfs.squashfs arm64/rootfs.squashfs
fi

if [[ -d aarch64be ]]; then
    gzip -f -k aarch64be/rootfs.btrfs
    copyone aarch64be/rootfs.btrfs.gz arm64be/rootfs.btrfs.gz
    copyone aarch64be/rootfs.cpio.gz arm64be/rootfs.cpio.gz
    copyone aarch64be/rootfs.ext2.gz arm64be/rootfs.ext2.gz
    copyone aarch64be/rootfs.iso.gz arm64be/rootfs.iso.gz
    copyone aarch64be/rootfs.squashfs arm64be/rootfs.squashfs
fi

if [[ -d alpha ]]; then
    copyone alpha/rootfs.cpio.gz alpha/rootfs.cpio.gz
    copyone alpha/rootfs.ext2.gz alpha/rootfs.ext2.gz

if [[ -d mips ]]; then
    copyone mips/rootfs.cpio.gz mips/rootfs.cpio.gz
    copyone mips/rootfs.ext2.gz mips/rootfs.ext2.gz
fi

if [[ -d mips64_n32 ]]; then
    copyone mips64_n32/rootfs.cpio.gz mips64/rootfs-n32.cpio.gz
    copyone mips64_n32/rootfs.ext2.gz mips64/rootfs-n32.ext2.gz
fi
if [[ -d mips64_n64 ]]; then
    copyone mips64_n64/rootfs.cpio.gz mips64/rootfs-n64.cpio.gz
    copyone mips64_n64/rootfs.ext2.gz mips64/rootfs-n64.ext2.gz
fi

if [[ -d mipsel_r1 ]]; then
    copyone mipsel_r1/rootfs.cpio.gz mipsel/rootfs.cpio.gz
    copyone mipsel_r1/rootfs.ext2.gz mipsel/rootfs-mipselr1.ext2.gz
fi
if [[ -d mipsel_r6 ]]; then
    copyone mipsel_r6/rootfs.ext2.gz mipsel/rootfs-mipselr6.ext2.gz
fi

if [[ -d ppc64 ]]; then
    copyone ppc64/rootfs.cpio.gz ppc64/rootfs.cpio.gz
    copyone ppc64/rootfs.ext2.gz ppc64/rootfs.ext2.gz
fi
if [[ -d ppc64le ]]; then
    copyone ppc64le/rootfs.cpio.gz ppc64/rootfs-el.cpio.gz
    copyone ppc64le/rootfs.ext2.gz ppc64/rootfs-el.ext2.gz
fi

if [[ -d riscv64 ]]; then
    copyone riscv64/rootfs.cpio.gz riscv64/rootfs.cpio.gz
    copyone riscv64/rootfs.ext2.gz riscv64/rootfs.ext2.gz
fi

if [[ -d x86_64 ]]; then
    gzip -f -k x86_64/rootfs.btrfs
    copyone x86_64/rootfs.btrfs.gz x86_64/rootfs.btrfs.gz
    copyone x86_64/rootfs.cpio.gz x86_64/rootfs.cpio.gz
    copyone x86_64/rootfs.ext2.gz x86_64/rootfs.ext2.gz
    copyone x86_64/rootfs.iso.gz x86_64/rootfs.iso.gz
    copyone x86_64/rootfs.squashfs x86_64/rootfs.squashfs
fi
