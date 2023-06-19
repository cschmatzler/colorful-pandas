local ns = import 'namespace.libsonnet';

{ namespace: ns.new('security') } +
(import 'cert-manager.jsonnet') +
(import 'onepassword-connect.jsonnet') +
(import 'external-secrets.jsonnet')
