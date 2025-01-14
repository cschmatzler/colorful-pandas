local k = import 'k.libsonnet',
      cm = k.core.v1.configMap;

{
  grafanaAgent:
    // Config
    {
      grafanaAgent+: {
        config: cm.new('grafana-agent-config', { 'config.river': importstr 'grafana-agent-config.river' }),
      },
    } +
    // ExternalSecret
    {
      local eslib = (import 'external-secrets.libsonnet').eslib,
      local esutil = (import 'external-secrets.libsonnet').esutil,
      local es = eslib.nogroup.v1beta1.externalSecret,
      grafanaAgent+: {
        externalSecrets+: {
          env: es.new('grafana-agent-env') +
               esutil.onepasswordStore() +
               es.spec.withData([
                 esutil.data('PROMETHEUS_URL', 'Grafana Cloud', 'PROMETHEUS_URL'),
                 esutil.data('PROMETHEUS_USERNAME', 'Grafana Cloud', 'PROMETHEUS_USERNAME'),
                 esutil.data('PROMETHEUS_PASSWORD', 'Grafana Cloud', 'PROMETHEUS_PASSWORD'),
                 esutil.data('TEMPO_URL', 'Grafana Cloud', 'TEMPO_URL'),
                 esutil.data('TEMPO_USERNAME', 'Grafana Cloud', 'TEMPO_USERNAME'),
                 esutil.data('TEMPO_PASSWORD', 'Grafana Cloud', 'TEMPO_PASSWORD'),
               ]),
        },
      },
    } +
    // Deployment
    (import 'grafana-agent/main.libsonnet') +
    {
      _config+:: {
        grafanaAgent+: {
          name: 'grafana-agent',
          namespace: 'monitoring',
          configMapName: 'grafana-agent-config',
          envSecretName: 'grafana-agent-env',
          extraValues: {
            agent: {
              extraPorts: [
                {
                  name: 'otlp-http',
                  port: 4318,
                  targetPort: 4318,
                },
              ],
            },
          },
        },
      },
    },
}
