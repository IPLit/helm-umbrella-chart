#!/bin/bash
cat <&0 > helm_kustomization/all.yaml
kustomize build helm_kustomization && rm helm_kustomization/all.yaml
