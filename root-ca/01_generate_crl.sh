#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

CA_NAME="root-ca"

CA_CONF=${CA_NAME}.cnf
# CA_KEY=private/${CA_NAME}.key
# CA_CSR=${CA_NAME}.csr
# CA_CRT=${CA_NAME}.crt
CA_CRL=crl/${CA_NAME}.crl

cd "${TOPDIR}" || exit 1

echo
echo "### Generating certificate revocation list..."
openssl ca \
        -gencrl \
        -config ${CA_CONF} \
        -out ${CA_CRL}

exit 0
