#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

if [ $# -lt 1 ]; then
    echo "Usage: ${BASEDIR}/$(basename "$0") [-a] cert_name"
    echo "  -a: Use SANs (Subject Alternative Names)"
    exit 1
fi

SAN=0
while getopts a OPT; do
    case ${OPT} in
        "a") SAN=1 ;;
        *)
            echo "Usage: ${BASEDIR}/$(basename "$0") [-a] cert_name"
            echo "  -a: Use SANs (Subject Alternative Names)"
            exit 1 ;;
    esac
done

shift $((OPTIND-1))

CERT_NAME=$1

if [ $SAN = 1 ]; then
    echo
    echo "Please specifiy subject alternative name(s) separated by space."
#    echo "Type Ctrl-D when finished."
    read -r ALTNAMES
    if [ -z "${ALTNAMES}" ]; then
        echo "SANs can not be empty. Exiting..."
        exit 1
    fi
    for i in ${ALTNAMES}; do
        if [ -z "${OPENSSL_SAN}" ]; then
            OPENSSL_SAN="DNS:${i}"
        else
            OPENSSL_SAN="${OPENSSL_SAN};DNS:${i}"
        fi
    done
    echo
    echo "Environment variable OPENSSL_SAN=${OPENSSL_SAN}"
fi

cd "${TOPDIR}" || exit 1

echo
echo "### Generating RSA private key..."
openssl genrsa \
        -out "${TOPDIR}/private/${CERT_NAME}_nopass.key" \
        2048

echo
echo "### Encrypting RSA private key..."
openssl rsa \
        -in "${TOPDIR}/private/${CERT_NAME}_nopass.key" \
        -out "${TOPDIR}/private/${CERT_NAME}.key" \
        -aes256

# echo
# echo "### Generating RSA public key..."
# openssl rsa \
#         -in "${TOPDIR}/private/${CERT_NAME}.key" \
#         -pubout \
#         -out "${TOPDIR}/certs/${CERT_NAME}.pub" \
#         -outform PEM

echo
echo "### Creatting ${CERT_NAME}'s certificate signing request..."
if [ $SAN = 1 ]; then
    env OPENSSL_SAN="${OPENSSL_SAN}" \
        openssl req \
            -new \
            -config "${TOPDIR}/openssl-san.cnf" \
            -key "${TOPDIR}/private/${CERT_NAME}.key" \
            -out "${TOPDIR}/certs/${CERT_NAME}.csr" \
            -sha512 \
            -reqexts v3_req
else
    openssl req \
        -new \
        -key "${TOPDIR}/private/${CERT_NAME}.key" \
        -out "${TOPDIR}/certs/${CERT_NAME}.csr" \
        -sha512
fi

exit 0
