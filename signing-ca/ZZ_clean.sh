#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
ROOTCA_TOP=${BASEDIR}

# NAME="signing-ca"

# ROOTCA_CONF=${NAME}.cnf
# ROOTCA_KEY=private/${NAME}.key
# ROOTCA_CSR=${NAME}.csr
# ROOTCA_CRT=${NAME}.crt
# ROOTCA_CRL=crl/${NAME}.crl

cd "${ROOTCA_TOP}" || exit 1

echo "Deleteing all files of Root CA..."
rm -rf certs crl db newcerts private
rm -f -- *.csr *.crt

exit 0
