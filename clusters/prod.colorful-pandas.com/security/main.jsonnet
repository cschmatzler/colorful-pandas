local ns = import 'namespace.libsonnet';

{ namespace: ns.new('security') } + (import 'cert-manager.jsonnet')

