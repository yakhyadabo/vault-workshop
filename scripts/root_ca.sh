#!/bin/bash

# Enable root ca backend
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki


# Generate root Certificate
vault write -format=json pki/root/generate/internal \
 common_name="example.com" ttl=87600h | tee \
>(jq -r .data.certificate > ca.pem) \
>(jq -r .data.issuing_ca > issuing_ca.pem) \
>(jq -r .data.private_key > ca-key.pem)


# Configure the CA and CRL URLs
vault write pki/config/urls \
        issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \
        crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"