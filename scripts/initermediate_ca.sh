#!/bin/bash

# Enable secret backend
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int


# Generate an intermediate
vault write -format=json pki_int/intermediate/generate/internal \
common_name="example.com Intermediate Authority" ttl=43800h | tee \
>(jq -r .data.csr > pki_intermediate.csr) \
>(jq -r .data.private_key > pki_intermediate.pem)


# Sign the certificate
vault write -format=json pki/root/sign-intermediate \
csr=@pki_intermediate.csr \
common_name="example.com Intermediate Authority" ttl=43800h | tee \
>(jq -r .data.certificate > pki_intermediate.cert.pem) \
>(jq -r .data.issuing_ca > pki_intermediate_issuing_ca.pem)


# Import to Vault
vault write pki_int/intermediate/set-signed certificate=@pki_intermediate.cert.pem


# Create role
vault write pki_int/roles/example-dot-com \
        allowed_domains="example.com" \
        allow_subdomains=true \
        max_ttl="720h"