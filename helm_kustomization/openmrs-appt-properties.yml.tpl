apiVersion: v1
kind: Secret
metadata:
  name: openmrs-appt-properties
data:
  appt.properties: "${OPENMRS_APPT_PROPERTIES}"
