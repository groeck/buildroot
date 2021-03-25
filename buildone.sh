#!/bin/bash

IMAGEDIR="images-$(git describe | cut -f1 -d-)"

buildone()
{
    local config="$1"
    local name="${config##kerneltests_}"
    name="${name%%_defconfig}"

    if [[ ! -e "configs/${config}" ]]; then
	echo "Configuration ${config} does not exist"
	return 1
    fi

    mkdir -p "${IMAGEDIR}"
    echo "Building ${name}"

    rm -rf output

    make ${config}
    if make; then
	rm -rf ""${IMAGEDIR}"/${name}"
	mv output/images ""${IMAGEDIR}"/${name}"
	if [[ -e "${IMAGEDIR}"/${name}/rootfs.btrfs ]]; then
	    gzip -f "${IMAGEDIR}"/${name}/rootfs.btrfs
	fi
	return 1
    fi
    return 0
}

(return 0 2>/dev/null) && sourced=1 || sourced=0

if [[ ${sourced} -eq 0 ]]; then
    for target in $*; do
	if [[ ! -e "configs/kerneltests_${target}_defconfig" ]]; then
	    echo "Configuration file for ${target} does not exist"
	    exit 1
	fi
	if ! buildone "kerneltests_${target}_defconfig"; then
	    echo "Failed to build ${target}"
	fi
    done
fi
