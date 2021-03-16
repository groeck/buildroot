mkdir -p images

build_one()
{
    local config="$1"
    local name="${config##kerneltests_}"
    name="${name%%_defconfig}"

    echo "Building ${name}"

    rm -rf output

    make ${config}
    if make; then
        rm -rf "images/${name}"
        mv output/images "images/${name}"
    fi
}

configs="$(cd configs; ls kerneltests*)"

for config in ${configs}; do
    build_one ${config}
done
