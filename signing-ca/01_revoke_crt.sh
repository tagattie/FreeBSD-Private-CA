#! /bin/sh

export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

BASEDIR=$(cd "$(dirname "$0")" && pwd)
TOPDIR=${BASEDIR}

CA_NAME="signing-ca"

CA_CONF=${CA_NAME}.cnf
# CA_KEY=private/${CA_NAME}.key
# CA_CSR=${CA_NAME}.csr
# CA_CRT=${CA_NAME}.crt
# CA_CRL=crl/${CA_NAME}.crl

if [ $# -ne 1 ]; then
    echo "Usage: ${BASEDIR}/$(basename "$0") serial_no"
    exit 1
fi

CERT=$1

echo
echo "Choose reason of revocation... (0-7):"
echo "  0 - unspecified"
echo "  1 - keyCompromise"
echo "  2 - CACompromise"
echo "  3 - affiliationChanged"
echo "  4 - superseded"
echo "  5 - cessationOfOperation"
echo "  6 - certificateHold"
echo "  7 - removeFromCRL"
read -r REASON_NO

case ${REASON_NO} in
    0) REASON=unspecified ;;
    1) REASON=keyCompromise ;;
    2) REASON=CACompromise ;;
    3) REASON=affiliationChanged ;;
    4) REASON=superseded ;;
    5) REASON=cessationOfOperation ;;
    6) REASON=certificateHold ;;
    7) REASON=removeFromCRL ;;
    *)
        echo "No such reason. Exiting..."
        exit 1 ;;
esac

cd "${TOPDIR}" || exit 1

echo
echo "### Revoking specified certificate..."
openssl ca \
        -config ${CA_CONF} \
        -revoke "${CERT}" \
        -crl_reason "${REASON}"

exit 0
