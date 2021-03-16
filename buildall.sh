. ./buildone.sh

configs="$(cd configs; ls kerneltests*)"

for config in ${configs}; do
    buildone ${config}
done
