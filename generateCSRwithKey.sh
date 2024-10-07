#!/bin/bash

# Array of FQDNs
fqdn_list=(
    "server01.domain.tld"
    "server02.domain.tld"
    ...
    "server99.domain.tld"
)

# Loop through each FQDN
for fqdn in "${fqdn_list[@]}"
do
    # Convert FQDN to certificate name format (replace dots with underscores)
    certname=$(echo $fqdn | sed 's/\./_/g').crt

    # Generate the private key for this FQDN
    openssl genpkey -algorithm RSA -out $fqdn.key -pkeyopt rsa_keygen_bits:2048

    # Create a unique OpenSSL config file for each CSR
    cat > openssl-$fqdn.cnf <<EOL
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[ dn ]
C = CA
ST = AB
L = Calgary
O = Company
CN = $fqdn

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $fqdn
EOL

    # Generate the CSR using the unique config file and key
    openssl req -new -sha256 -key $fqdn.key -out $certname.csr -config openssl-$fqdn.cnf

    echo "Generated key and CSR for $fqdn: $certname.csr"
done
