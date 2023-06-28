local ns = import 'namespace.libsonnet';

{ namespace: ns.new('monitoring') } +
(import 'grafana-agent-logs.jsonnet') +
(import 'grafana-agent-traces.jsonnet')
