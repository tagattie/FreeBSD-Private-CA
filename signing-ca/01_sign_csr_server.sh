#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

CA_NAME="signing-ca"

CA_CONF=${CA_NAME}.cnf
# CA_KEY=private/${CA_NAME}.key
# CA_CSR=${CA_NAME}.csr
CA_CRT=${CA_NAME}.crt
# CA_CRL=crl/${CA_NAME}.crl

if [ $# -ne 1 ]; then
    echo "Usage: ${BASEDIR}/$(basename "$0") cert_name"
    exit 1
fi

CERT_NAME=$1

cd "${TOPDIR}" || exit 1

echo
echo "### Signing certificate request..."
openssl ca \
        -config ${CA_CONF} \
        -policy policy_anything \
        -in "${TOPDIR}/${CERT_NAME}.csr" \
        -out "${TOPDIR}/${CERT_NAME}.crt" \
        -md sha512 \
        -extensions server_ext

echo
echo "### Stripping text part from the certificate..."
openssl x509 \
        -in "${TOPDIR}/${CERT_NAME}.crt" \
        -out "${TOPDIR}/${CERT_NAME}.crt.notext"

echo
echo "### Concatenating the certificates to make a full-chain certificate..."
cat "${TOPDIR}/${CERT_NAME}.crt.notext" ${CA_CRT}.notext > "${CERT_NAME}.crt.full"

exit 0
