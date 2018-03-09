#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

CA_NAME="root-ca"

CA_CONF=${CA_NAME}.cnf
CA_KEY=private/${CA_NAME}.key
CA_CSR=${CA_NAME}.csr
CA_CRT=${CA_NAME}.crt
CA_CRL=crl/${CA_NAME}.crl

echo
echo "### Preparing initial files and directories..."
if [ ! -d "${TOPDIR}" ]; then
    mkdir -p "${TOPDIR}"
fi
cd "${TOPDIR}" || exit 1
for i in certs crl db newcerts private; do
    mkdir -p "${i}"
done
chmod 700 private
if [ ! -f "db/index" ]; then
    touch db/index
fi
if [ ! -f "db/serial" ]; then
   openssl rand -hex 16 > db/serial
fi
if [ ! -f "db/crlnumber" ]; then
    echo "1001" > db/crlnumber
fi

echo
echo "### Generating Root CA's private key..."
openssl ecparam -name secp384r1 -genkey | \
    openssl ec -out ${CA_KEY} -aes256

echo
echo "### Creating Root CA's certificate signing request..."
openssl req -new \
        -config ${CA_CONF} \
        -key ${CA_KEY} \
        -out ${CA_CSR} \
        -sha512

echo
echo "### Self-signing certificate request..."
openssl ca \
        -config ${CA_CONF} \
        -in ${CA_CSR} \
        -out ${CA_CRT} \
        -md sha512 \
        -selfsign \
        -extensions v3_ca

# echo "### Stripping text part of the certificate..."
# openssl x509 \
#         -in ${CA_CRT} \
#         -out ${CA_CRT}.notext

echo
echo "### Generating certificate revocation list..."
openssl ca \
        -gencrl \
        -config ${CA_CONF} \
        -out ${CA_CRL}

exit 0
