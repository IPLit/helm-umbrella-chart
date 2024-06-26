#!/bin/bash
set -e

function exportWithMask {
    SSM_PARAMETER_NAME=$1
    ENV_VARIABLE_NAME=$2

    PARAMETER_VALUE=$(aws ssm get-parameter --with-decryption --name "$SSM_PARAMETER_NAME" --query "Parameter.Value" --output text)
    echo "export $ENV_VARIABLE_NAME=\"$PARAMETER_VALUE\""
}

function exportEncodedWithMask {
    SSM_PARAMETER_NAME=$1
    ENV_VARIABLE_NAME=$2

    PARAMETER_VALUE=$(aws ssm get-parameter --with-decryption --name "$SSM_PARAMETER_NAME" --query "Parameter.Value" --output text )
    echo "export $ENV_VARIABLE_NAME=\"$(echo -n $PARAMETER_VALUE | base64)\""
}

ENVIRONMENT=$1
ENVIRONMENT_CLUSTER=$2
DB_TENANT=$3

if [ -n "$DB_TENANT" ]; then
    DB_TENANT=$DB_TENANT
else
    DB_TENANT=$ENVIRONMENT_CLUSTER
fi;
echo $DB_TENANT


exportWithMask "/$ENVIRONMENT/openmrs/DB_USERNAME" 'OPENMRS_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/openmrs/DB_PASSWORD" 'OPENMRS_DB_PASSWORD'
exportWithMask "/$ENVIRONMENT/openmrs/OMRS_ADMIN_USER_PASSWORD" 'OMRS_ADMIN_USER_PASSWORD'

exportWithMask "/$ENVIRONMENT/reports/DB_USERNAME" 'REPORTS_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/reports/DB_PASSWORD" 'REPORTS_DB_PASSWORD'
exportWithMask "/$ENVIRONMENT/crater/DB_USERNAME" 'CRATER_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/crater/DB_PASSWORD" 'CRATER_DB_PASSWORD'

exportEncodedWithMask "/$ENVIRONMENT/crater/CRATER_MAIL_USERNAME" 'CRATER_MAIL_USERNAME'
exportEncodedWithMask "/$ENVIRONMENT/crater/CRATER_MAIL_PASSWORD" 'CRATER_MAIL_PASSWORD'
exportEncodedWithMask "/$ENVIRONMENT/crater/CRATER_MAIL_HOST" 'CRATER_MAIL_HOST'

exportEncodedWithMask "/$ENVIRONMENT/crater/CRATER_MAIL_FROM_ADDRESS" 'CRATER_MAIL_FROM_ADDRESS'
exportEncodedWithMask "/$ENVIRONMENT/crater/CRATER_MAIL_FROM_NAME" 'CRATER_MAIL_FROM_NAME'

exportWithMask "/$ENVIRONMENT/crater_atomfeed/DB_USERNAME" 'CRATER_ATOMFEED_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/crater_atomfeed/DB_PASSWORD" 'CRATER_ATOMFEED_DB_PASSWORD'
exportWithMask "/$ENVIRONMENT/crater/ADMIN_PASSWORD" 'CRATER_ADMIN_PASSWORD'
exportWithMask "/$DB_TENANT/rds/mysql/host" 'RDS_HOST'
exportWithMask "/$DB_TENANT/rds/mysql/username" 'RDS_USERNAME'
exportWithMask "/$DB_TENANT/rds/mysql/password" 'RDS_PASSWORD'
exportWithMask "/$ENVIRONMENT_CLUSTER/rabbitmq/USERNAME" 'MQ_USERNAME'
exportWithMask "/$ENVIRONMENT_CLUSTER/rabbitmq/PASSWORD" 'MQ_PASSWORD'
exportWithMask "/$ENVIRONMENT_CLUSTER/psql/DB_PASSWORD" 'PSQL_PASSWORD'
exportWithMask "/$ENVIRONMENT/abdm/GATEWAY_CLIENT_ID" 'GATEWAY_CLIENT_ID'
exportWithMask "/$ENVIRONMENT/abdm/GATEWAY_CLIENT_SECRET" 'GATEWAY_CLIENT_SECRET'
exportWithMask "/$ENVIRONMENT_CLUSTER/efs/file_system_id" 'EFS_FILESYSTEM_ID'
exportWithMask "/smtp/access_key" 'MAIL_USER'
exportWithMask "/smtp/secret" 'MAIL_PASSWORD'
exportWithMask "/$ENVIRONMENT/metabase/ADMIN_EMAIL" 'MB_ADMIN_EMAIL'
exportWithMask "/$ENVIRONMENT/metabase/ADMIN_PASSWORD" 'MB_ADMIN_PASSWORD'
exportWithMask "/$ENVIRONMENT/metabase/MB_DB_USER" 'MB_DB_USER'
exportWithMask "/$ENVIRONMENT/metabase/MB_DB_PASS" 'MB_DB_PASS'
exportWithMask "/$ENVIRONMENT/bahmni_mart/DB_USERNAME" 'MART_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/bahmni_mart/DB_PASSWORD" 'MART_DB_PASSWORD'
exportWithMask "/$ENVIRONMENT/sms/SMS_TOKEN" 'SMS_TOKEN'
