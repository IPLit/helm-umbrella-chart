#!/bin/bash

TENANT_NAME=$1
NODEGROUP_NAME=$2

cat clinic.yaml.tpl | sed "s@TENANT_NAME@$TENANT_NAME@g; s@NODEGROUP_NAME@$NODEGROUP_NAME@g;" > ../values/$TENANT_NAME.yaml
cp -r -v default_logo ../cloudfront/$TENANT_NAME
sed -i "38s@^\( *\)@\          - $TENANT_NAME\n          @" ../.github/workflows/deploy.yaml

GATEWAY_CLIENT_ID=$(aws ssm get-parameter --with-decryption --name "/bootstrap/bahmnilite/GATEWAY_CLIENT_ID" --query "Parameter.Value" --output text)
GATEWAY_CLIENT_SECRET=$(aws ssm get-parameter --with-decryption --name "/bootstrap/bahmnilite/GATEWAY_CLIENT_SECRET" --query "Parameter.Value" --output text)
METABASE_ADMIN_EMAIL=$(aws ssm get-parameter --with-decryption --name "/bootstrap/bahmnilite/METABASE_ADMIN_EMAIL" --query "Parameter.Value" --output text)
METABASE_ADMIN_PASSWORD=$(aws ssm get-parameter --with-decryption --name "/bootstrap/bahmnilite/METABASE_ADMIN_PASSWORD" --query "Parameter.Value" --output text)
CRATER_ADMIN_PASSWORD=$(aws ssm get-parameter --with-decryption --name "/bootstrap/bahmnilite/CRATER_ADMIN_PASSWORD" --query "Parameter.Value" --output text)

function generatePassword {
    tr -dc 'A-Za-z0-9!#$%&\()*+<=>?@[\]^_`{}~' </dev/urandom | head -c 10  ; echo
}

function createParameter {
    PARAMETER_NAME=$1
    PARAMETER_VALUE=$2
    PARAMETER_NOT_FOUND_FLAG=$(aws ssm get-parameter --name $PARAMETER_NAME 2>&1 | sed -n '/ParameterNotFound/p' | wc -l)
    if [ "$PARAMETER_NOT_FOUND_FLAG" != "0" ]; then
        aws ssm put-parameter --name $PARAMETER_NAME --value $PARAMETER_VALUE --type "SecureString"
    fi
}

MART_DB_USERNAME="bahmni-mart"
MART_DB_PASSWORD=$(generatePassword)
CRATER_DB_USERNAME=$TENANT_NAME"_admin"
CRATER_DB_PASSWORD=$(generatePassword)
CRATER_ATOMFEED_DB_USERNAME=$CRATER_DB_USERNAME
CRATER_ATOMFEED_DB_PASSWORD=$CRATER_DB_PASSWORD
METABASE_DB_USERNAME="metabase-user"
METABASE_DB_PASSWORD=$(generatePassword)
OPENMRS_DB_USERNAME=$TENANT_NAME"_superman"
OPENMRS_DB_PASSWORD=$(generatePassword)
REPORTS_DB_USERNAME=$TENANT_NAME"-bahmni-report"
REPORTS_DB_PASSWORD=$(generatePassword)


IF_EXIST=$(aws ssm get-parameter --name "/test" 2>&1 | sed -n '/ParameterNotFound/p' | wc -l)

createParameter "/$TENANT_NAME/abdm/GATEWAY_CLIENT_ID" $GATEWAY_CLIENT_ID
createParameter "/$TENANT_NAME/abdm/GATEWAY_CLIENT_SECRET" $GATEWAY_CLIENT_SECRET
createParameter "/$TENANT_NAME/bahmni_mart/DB_PASSWORD" $MART_DB_PASSWORD
createParameter "/$TENANT_NAME/bahmni_mart/DB_USERNAME" $MART_DB_USERNAME
createParameter "/$TENANT_NAME/crater/ADMIN_PASSWORD" $CRATER_ADMIN_PASSWORD
createParameter "/$TENANT_NAME/crater/DB_PASSWORD" $CRATER_DB_PASSWORD
createParameter "/$TENANT_NAME/crater/DB_USERNAME" $CRATER_DB_USERNAME
createParameter "/$TENANT_NAME/crater/CRATER_MAIL_USERNAME" "dummy"
createParameter "/$TENANT_NAME/crater/CRATER_MAIL_PASSWORD" "dummy"
createParameter "/$TENANT_NAME/crater/CRATER_MAIL_HOST" "dummy"
createParameter "/$TENANT_NAME/crater/CRATER_MAIL_FROM_ADDRESS" "dummy"
createParameter "/$TENANT_NAME/crater/CRATER_MAIL_FROM_NAME" "dummy"
createParameter "/$TENANT_NAME/crater_atomfeed/DB_PASSWORD" $CRATER_ATOMFEED_DB_PASSWORD
createParameter "/$TENANT_NAME/crater_atomfeed/DB_USERNAME" $CRATER_ATOMFEED_DB_USERNAME
createParameter "/$TENANT_NAME/metabase/ADMIN_EMAIL" $METABASE_ADMIN_EMAIL
createParameter "/$TENANT_NAME/metabase/ADMIN_PASSWORD" $METABASE_ADMIN_PASSWORD
createParameter "/$TENANT_NAME/metabase/MB_DB_PASS" $METABASE_DB_PASSWORD
createParameter "/$TENANT_NAME/metabase/MB_DB_USER" $METABASE_DB_USERNAME
createParameter "/$TENANT_NAME/openmrs/DB_PASSWORD" $OPENMRS_DB_PASSWORD
createParameter "/$TENANT_NAME/openmrs/DB_USERNAME" $OPENMRS_DB_USERNAME
createParameter "/$TENANT_NAME/reports/DB_USERNAME" $REPORTS_DB_USERNAME
createParameter "/$TENANT_NAME/reports/DB_PASSWORD" $REPORTS_DB_PASSWORD
createParameter "/$TENANT_NAME/hip/BAHMNI_NAME" $TENANT_NAME
createParameter "/$TENANT_NAME/sms/SMS_TOKEN" "dummy"
createParameter "/$TENANT_NAME/sms/SMS_ORIGINATOR" "dummy"
createParameter "/$TENANT_NAME/sms/SMS_PROVIDER_API" "dummy"
createParameter "/$TENANT_NAME/sms/SMS_COUNTRY_CODE" "+91"
