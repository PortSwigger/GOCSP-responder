#!/bin/bash

#DEPOT=/depot
PKCS11CONF=${DEPOT}/pkcs11-config.json
#REGION=eu-west-1

# things that should exist in parameter store manager and be available to us via env variables
#SM_PKCS11_CONF=""     # an ARN of the config used by scepserver -pkcs11-config argument
#SM_KMS_CONFIG=""      # an ARN of the config file used by the pkcs11 shim to be stored in /etc/aws-kms-pkcs11/config.json

# expose as ENV var
#SM_CMD_SECRETS_ARN=""

# takes secret arn, secret name. returns just the secret.
getsecretvalue() {
        aws secretsmanager get-secret-value --secret-id $1 --region=${REGION} | jq --raw-output '.SecretString' | jq -r .$2 
}

# takes secretarn, filename to write contents to
getsecretblob() {
        aws secretsmanager get-secret-value --secret-id $1 --region ${REGION} --query SecretBinary  | sed s/\"//g | base64 -d > $2
        echo grabbing $1 saving to $2
}

# First up, check to see if our pkcs11 config file exists, and grab it if not.
if [ ! -f ${PKCS11CONF} ]; then
        getsecretblob ${SM_PKCS11_CONF} ${PKCS11CONF}
fi

# next, we need to grab our aws-kms-pkcs11 config.
# this test is redundant but makes it look pretty :-)
if [ ! -f /etc/aws-kms-pkcs11/config.json ]; then
        mkdir -p /etc/aws-kms-pkcs11/
        getsecretblob ${SM_KMS_CONFIG} /etc/aws-kms-pkcs11/config.json
fi

# we should be able to start now.
echo "attempting to start server"
./go-ocsp-responder -stdout -port ${PORT} -cacert ${CACERT} -p11conf ${PKCS11CONF}