#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

CA_NAME="signing-ca"

CA_CONF=${CA_NAME}.cnf
CA_KEY=private/${CA_NAME}.key
CA_CSR=${CA_NAME}.csr
# CA_CRT=${CA_NAME}.crt
# CA_CRL=crl/${CA_NAME}.crl

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
echo "### Generating Signing CA's private key..."
openssl ecparam -name secp384r1 -genkey | \
    openssl ec -out ${CA_KEY} -aes256

echo "### Creating Signing CA's certificate signing request..."
openssl req -new \
        -config ${CA_CONF} \
        -key ${CA_KEY} \
        -out ${CA_CSR} \
        -sha512

exit 0
