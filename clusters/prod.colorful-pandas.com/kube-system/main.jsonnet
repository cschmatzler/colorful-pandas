local ns = import 'namespace.libsonnet';

{ namespace: ns.new('kube-system') } +
{ hcloud_ccm: import 'hcloud-ccm.jsonnet' }

