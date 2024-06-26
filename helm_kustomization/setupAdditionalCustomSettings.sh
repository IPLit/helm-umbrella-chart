#!/bin/bash
set -e

ENVIRONMENT=$1


export CRATER_MAIL_USERNAME=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_USERNAME" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_PASSWORD=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_PASSWORD" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_HOST=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_HOST" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_FROM_ADDRESS=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_FROM_ADDRESS" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_FROM_NAME=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_FROM_NAME" --query "Parameter.Value" --output text) | base64)
export BAHMNI_NAME=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/hip/BAHMNI_NAME" --query "Parameter.Value" --output text))

export OMRS_ADMIN_USER_PASSWORD=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/openmrs/OMRS_ADMIN_USER_PASSWORD" --query "Parameter.Value" --output text) | base64)

export SMS_ORIGINATOR=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/sms/SMS_ORIGINATOR" --query "Parameter.Value" --output text))
export SMS_PROVIDER_API=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/sms/SMS_PROVIDER_API" --query "Parameter.Value" --output text))
export SMS_COUNTRY_CODE=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/sms/SMS_COUNTRY_CODE" --query "Parameter.Value" --output text))


envsubst < helm_kustomization/crater-mail-secrets.yml.tpl > helm_kustomization/crater-mail-secrets.yml
envsubst < helm_kustomization/openmrs-secrets.yml.tpl > helm_kustomization/openmrs-secrets.yml
envsubst < helm_kustomization/hip-atomfeed-secrets.yml.tpl > helm_kustomization/hip-atomfeed-secrets.yml

envsubst < helm_kustomization/hip-config-map.yml.tpl > helm_kustomization/hip-config-map.yml
envsubst < helm_kustomization/sms-config-map.yml.tpl > helm_kustomization/sms-config-map.yml


unset CRATER_MAIL_USERNAME \
    CRATER_MAIL_PASSWORD \
    CRATER_MAIL_HOST \
    CRATER_MAIL_FROM_ADDRESS \
    CRATER_MAIL_FROM_NAME \
    SMS_ORIGINATOR \
    SMS_PROVIDER_API \
    SMS_COUNTRY_CODE \
    OMRS_ADMIN_USER_PASSWORD
