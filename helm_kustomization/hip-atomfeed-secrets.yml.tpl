apiVersion: v1
kind: Secret
metadata:
  name: hip-atomfeed-secrets
type: Opaque
data:
  OPENMRS_PASSWORD: "${OMRS_ADMIN_USER_PASSWORD}"
