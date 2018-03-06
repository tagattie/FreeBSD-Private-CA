#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

cd "${TOPDIR}" || exit 1

echo
echo "### Deleteing all private keys and certificates..."
rm -f -- certs/* private/*

exit 0
