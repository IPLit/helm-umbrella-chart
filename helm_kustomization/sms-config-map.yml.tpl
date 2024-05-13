apiVersion: v1
kind: ConfigMap
metadata:
  name: sms-service-config
data:
  SMS_ORIGINATOR: "${SMS_ORIGINATOR}"
  SMS_PROVIDER_API: "${SMS_PROVIDER_API}"
  SMS_COUNTRY_CODE: "${SMS_COUNTRY_CODE}"
