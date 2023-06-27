local ns = import 'namespace.libsonnet';

{ namespace: ns.new('networking', is_privileged=true) } +
(import 'cilium.jsonnet') +
(import 'contour.jsonnet') +
(import 'external-dns.jsonnet')
