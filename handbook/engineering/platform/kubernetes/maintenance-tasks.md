# Maintenance Tasks

## Upgrading Flux

Flux upgrades need to applied manually. After increasing the OCR repository version, apply it to the cluster by running `kubectl apply -f clusters/platform/bootstrap/flux.yaml`.  
The other manifests in `bootstrap/` don't need to be re-applied.
