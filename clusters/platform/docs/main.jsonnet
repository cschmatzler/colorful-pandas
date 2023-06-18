local ns = import 'namespace.libsonnet';

{ namespace: ns.new('docs') } + (import 'handbook.jsonnet')
