#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

echo
echo "### Preparing initial directories..."
if [ ! -d "${TOPDIR}" ]; then
    mkdir -p "${TOPDIR}"
fi
cd "${TOPDIR}" || exit 1
for i in certs private; do
    mkdir -p "${i}"
done
chmod 700 private

exit 0
