local ns = import 'namespace.libsonnet';

{ namespace: ns.new('networking', is_privileged=true) } +
{ cilium: import 'cilium.jsonnet' }
