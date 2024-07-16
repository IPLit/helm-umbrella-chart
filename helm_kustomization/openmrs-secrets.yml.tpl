apiVersion: v1
kind: Secret
metadata:
  name: openmrs-secrets
type: Opaque
data:
  OMRS_ADMIN_USER_PASSWORD: "${OMRS_ADMIN_USER_PASSWORD}"
