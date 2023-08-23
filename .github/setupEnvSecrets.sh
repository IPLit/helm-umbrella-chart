#!/bin/bash
set -e

function exportWithMask {
    SSM_PARAMETER_NAME=$1
    ENV_VARIABLE_NAME=$2

    PARAMETER_VALUE=$(aws ssm get-parameter --with-decryption --name "$SSM_PARAMETER_NAME" --query "Parameter.Value" --output text)
    echo "::add-mask::$PARAMETER_VALUE"
    echo "$ENV_VARIABLE_NAME=$PARAMETER_VALUE" >> $GITHUB_ENV
}

function generate_values_file_part {
    SSM_PARAMETER_NAME=$1
    VALUES_FILE=$2

    aws ssm get-parameter --name $SSM_PARAMETER_NAME --with-decryption  --output text --query Parameter.Value >> $VALUES_FILE
}

ENVIRONMENT=$1
ENVIRONMENT_CLUSTER=$2
IS_CONFIG_FROM_SSM=$3
DB_TENANT=$4

if [ -n "$DB_TENANT" ]; then
    DB_TENANT=$DB_TENANT
else
    DB_TENANT=$ENVIRONMENT_CLUSTER
fi;

exportWithMask "/$ENVIRONMENT/openmrs/DB_USERNAME" 'OPENMRS_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/openmrs/DB_PASSWORD" 'OPENMRS_DB_PASSWORD'
exportWithMask "/$ENVIRONMENT/reports/DB_USERNAME" 'REPORTS_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/reports/DB_PASSWORD" 'REPORTS_DB_PASSWORD'
exportWithMask "/$ENVIRONMENT/crater/DB_USERNAME" 'CRATER_DB_USERNAME'
exportWithMask "/$ENVIRONMENT/crater/DB_PASSWORD" 'CRATER_DB_PASSWORD'
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


if [ $IS_CONFIG_FROM_SSM == 'true' ]; then

VALUES_FILENAME=values/$ENVIRONMENT.yaml
    touch $VALUES_FILENAME

    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/global" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/metadata" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/openmrs" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/bahmni-web" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/bahmni-lab" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/crater" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/reports" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/hiu" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/hiu-db" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/hiu-ui" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/hip" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/otp-service" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/hip-atomfeed" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/postgresql" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/rabbitmq" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/patient-documents" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/appointments" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/crater-atomfeed" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/implementer-interface" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/clinic-config" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/abha-verification" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/bahmni-metabase" $VALUES_FILENAME
    generate_values_file_part "/$ENVIRONMENT_CLUSTER/$ENVIRONMENT/helm_values/bahmni-mart" $VALUES_FILENAME
fi