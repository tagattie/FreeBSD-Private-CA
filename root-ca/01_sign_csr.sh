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
# CA_CRL=crl/${CA_NAME}.crl

SUB_CA_NAME="signing-ca"

SUB_CA_CSR=${SUB_CA_NAME}.csr
SUB_CA_CRT=${SUB_CA_NAME}.crt

cd "${TOPDIR}" || exit 1

echo
echo "### Signing Sub CA's certificate..."
openssl ca \
        -config ${CA_CONF} \
        -in ${SUB_CA_CSR} \
        -out ${SUB_CA_CRT} \
        -md sha512 \
        -extensions v3_sub_ca

exit 0
