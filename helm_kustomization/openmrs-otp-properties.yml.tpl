apiVersion: v1
kind: Secret
metadata:
  name: openmrs-otp-properties
data:
  otp.properties: "${OPENMRS_OTP_PROPERTIES}"
