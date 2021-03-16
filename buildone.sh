#!/bin/bash

buildone()
{
    local config="$1"
    local name="${config##kerneltests_}"
    name="${name%%_defconfig}"

    mkdir -p images
    echo "Building ${name}"

    rm -rf output

    make ${config}
    if make; then
	rm -rf "images/${name}"
	mv output/images "images/${name}"
	if [[ -e output/images/${name}/rootfs.btrfs ]]; then
	    gzip -f output/images/${name}/rootfs.btrfs
	fi
    fi
}

(return 0 2>/dev/null) && sourced=1 || sourced=0

if [[ ${sourced} -eq 0 ]]; then
    for target in $*; do
	if [[ ! -e "configs/kerneltests_${target}_defconfig" ]]; then
	    echo "Configuration for ${target} does not exist"
	    exit 1
	fi
	buildone "kerneltests_${target}_defconfig"
    done
fi
