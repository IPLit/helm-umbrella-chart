#!/bin/bash

TENANT=$1
CERTIFICATE_ARN=$2
INGRESS_NLB_DNS_NAME=$3

IMAGE_TAG=$(cat ../values/$TENANT.yaml | yq .bahmni-web.image.tag)

docker pull infoiplitin/bahmni-iplit-web:$IMAGE_TAG
IMG_ID=$(docker create infoiplitin/bahmni-iplit-web:$IMAGE_TAG)
docker cp $IMG_ID:/usr/local/apache2/htdocs ./static

cp $TENANT/bahmniLogoFull.png static/bahmni/images/bahmniLogoFull.png || echo "No such file"
cp $TENANT/visitPrintHeader.png static/bahmni/images/visitPrintHeader.png || echo "No such file"
cp $TENANT/index.html static/index.html || echo "No such file"

cat main.tf.tpl | sed "s@TENANT@$TENANT@g; s@CERTIFICATE_ARN@$CERTIFICATE_ARN@g; s@INGRESS_NLB_DNS_NAME@$INGRESS_NLB_DNS_NAME@g;" > main.tf
