local ns = import 'namespace.libsonnet';

{ namespace: ns.new('monitoring', is_privileged=true) } +
(import 'node-exporter.jsonnet') +
(import 'kube-state-metrics.jsonnet') +
(import 'grafana-agent.jsonnet')
