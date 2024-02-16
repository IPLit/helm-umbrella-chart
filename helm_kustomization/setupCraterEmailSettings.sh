#!/bin/bash
set -e

ENVIRONMENT=$1


export CRATER_MAIL_USERNAME=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_USERNAME" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_PASSWORD=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_PASSWORD" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_HOST=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_HOST" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_FROM_ADDRESS=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_FROM_ADDRESS" --query "Parameter.Value" --output text) | base64)
export CRATER_MAIL_FROM_NAME=$(echo -n $(aws ssm get-parameter --with-decryption --name "/$ENVIRONMENT/crater/CRATER_MAIL_FROM_NAME" --query "Parameter.Value" --output text) | base64)

envsubst < helm_kustomization/crater-mail-secrets.yml.tpl > helm_kustomization/crater-mail-secrets.yml

unset CRATER_MAIL_USERNAME CRATER_MAIL_PASSWORD CRATER_MAIL_HOST CRATER_MAIL_FROM_ADDRESS CRATER_MAIL_FROM_NAME
