local ns = import 'namespace.libsonnet';

{ namespace: ns.new('kube-system') } +
(import 'hcloud-ccm.jsonnet')
