local k = import 'k.libsonnet',
      cm = k.core.v1.configMap;

{
  grafanaAgentLogs:
    {
      // Config
      grafanaAgent+: {
        config: cm.new('grafana-agent-logs-config', { 'config.river': importstr 'grafana-agent-logs-config.river' }),
      },
    } +
    // ExternalSecret
    {
      local eslib = (import 'external-secrets.libsonnet').eslib,
      local esutil = (import 'external-secrets.libsonnet').esutil,
      local es = eslib.nogroup.v1beta1.externalSecret,
      grafanaAgent+: {
        externalSecrets+: {
          env: es.new('grafana-agent-logs-env') +
               esutil.onepasswordStore() +
               es.spec.withData([
                 esutil.data('LOKI_URL', 'Grafana Cloud', 'LOKI_URL'),
               ]),
        },
      },
    } +
    // Deployment
    (import 'grafana-agent/main.libsonnet') +
    {
      _config+:: {
        grafanaAgent+: {
          name: 'grafana-agent-logs',
          namespace: 'monitoring',
          type: 'daemonset',
          configMapName: 'grafana-agent-logs-config',
          envSecretName: 'grafana-agent-logs-env',
          manageCRDs: false,
        },
      },
    },
}
