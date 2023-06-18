local ns = import 'namespace.libsonnet';

{ namespace: ns.new('networking', is_privileged=true) } + (import 'cilium.jsonnet') + {} + {}
