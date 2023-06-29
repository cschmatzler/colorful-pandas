local ns = import 'namespace.libsonnet';

{ namespace: ns.new('monitoring') } +
(import 'grafana-agent.jsonnet')
