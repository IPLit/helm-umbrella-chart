#!/bin/bash

TENANT=$1
CERTIFICATE_ARN=$2
INGRESS_NLB_DNS_NAME=$3

mkdir -p static
aws s3 sync s3://iplit-static-webapp/ ./static/

cp $TENANT/bahmniLogoFull.png static/bahmni/images/bahmniLogoFull.png || echo "No such file"
cp $TENANT/visitPrintHeader.png static/bahmni/images/visitPrintHeader.png || echo "No such file"

cat main.tf.tpl | sed "s@TENANT@$TENANT@g; s@CERTIFICATE_ARN@$CERTIFICATE_ARN@g; s@INGRESS_NLB_DNS_NAME@$INGRESS_NLB_DNS_NAME@g;" > main.tf
