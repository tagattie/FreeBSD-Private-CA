# FreeBSD-Private-CA
Scripts for creating and managing a two-tier simple private CA for FreeBSD.

## Checkout

```shell
git clone https://github.com/tagattie/FreeBSD-Private-CA.git
cd FreeBSD-Private-CA
```

## Setup Root CA

```shell
cd root-ca
./00_setup_root-ca.sh
```

The Root CA certificate is `root-ca.crt`.

## Setup Signing CA

```shell
cd ../signing-ca
./00_setup_signing-ca.sh
```

The Signing CA's CSR is `signing-ca.csr`.

```shell
cp signing-ca.csr ../root-ca 
cd ../root-ca
./01_sign_csr.sh
```

The Signing CA's certificate is `signing-ca.crt`.

```shell
cp signing-ca.crt ../signing-ca
```

Strip the text part from the signing CA's certificate for later use.

```shell
cd ../signing-ca
./01_strip_crt_text.sh
```

Now you are all set for signing server/client certificates.

## Creating Server/Client Certificate

If you would like to use FreeBSD's default OpenSSL configuration directory (`/etc/ssl`), please copy the shell scripts and the config file into it.

``` shell
cd FreeBSD-Private-CA
cp *.sh *.cnf /etc/ssl
cd /etc/ssl
./00_setup.sh
```

### Creating CSR

- Execute the script `01_create_csr.sh`

    Use `-a` option if you would like to use SANs (Subject Alternative Names). If you specify `-a`, you will be prompted for SANs illustrated as below.

```shell-session
$ ./01_create_csr.sh -a example

Please specifiy subject alternative name(s) separated by space.
example.com openvpn.example.com vpn.example.com

Environment variable OPENSSL_SAN=DNS:example.com;DNS:openvpn.example.com;DNS:vpn.example.com

### Generating RSA private key...
Generating RSA private key, 2048 bit long modulus
..........................................................+++
............+++
e is 65537 (0x10001)

### Encrypting RSA private key...
writing RSA key
Enter PEM pass phrase:<passphrase>
Verifying - Enter PEM pass phrase:<passphrase>

### Creatting example's certificate signing request...
Enter pass phrase for /home/tagattie/work/tagattie/FreeBSD-Private-CA/private/example.key:<passphrase>
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:JP
State or Province Name (full name) [Some-State]:Kanagawa
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example Org
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:example.com
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

- Copy the CSR to the Signing CA's directory.

``` shell
cp certs/example.csr FreeBSD-Private-CA/signing-ca
```

### Signing CSR by Singing CA

Change into the Signing CA's directory and execute `01_sign_csr_server.sh` for a server certificate, or `01_sign_csr_client.sh` for a client certificate.

```shell
cd FreeBSD-Private-CA/signing-ca
./01_sign_csr_server.sh example (for server cert)
   or
./01_sign_csr_client.sh example (for client cert)
```

The server/client's certificate is `example.crt`. `example.crt.full` is a full-chain certificate including both server/client's and signing ca's certificates.

## Revoking Server/Client Certificate

Change into the signing CA's directory and execute `01_revoke_crt.sh`.

```shell
cd FreeBSD-Private-CA/signing-ca
./01_revoke_crt.sh newcerts/<cert's serial number>.pem
```

An output from an example execution is as follows:

```shell-session
$ ./01_revoke_crt.sh newcerts/4F48D09643300C499DA6F6F3707FAE94.pem

Choose reason of revocation... (0-7):
  0 - unspecified
  1 - keyCompromise
  2 - CACompromise
  3 - affiliationChanged
  4 - superseded
  5 - cessationOfOperation
  6 - certificateHold
  7 - removeFromCRL
1

### Revoking specified certificate...
Using configuration from signing-ca.cnf
Enter pass phrase for ./private/signing-ca.key:<passphrase>
Revoking Certificate 4F48D09643300C499DA6F6F3707FAE94.
Data Base Updated
```
