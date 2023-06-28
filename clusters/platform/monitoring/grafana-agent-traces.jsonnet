local k = import 'k.libsonnet',
      cm = k.core.v1.configMap;

{
  grafanaAgentTraces:
    // Config
    {
      grafanaAgent+: {
        config: cm.new('grafana-agent-traces-config', { 'config.river': importstr 'grafana-agent-traces-config.river' }),
      },
    } +
    // ExternalSecret
    {
      local eslib = (import 'external-secrets.libsonnet').eslib,
      local esutil = (import 'external-secrets.libsonnet').esutil,
      local es = eslib.nogroup.v1beta1.externalSecret,
      grafanaAgent+: {
        externalSecrets+: {
          env: es.new('grafana-agent-traces-env') +
               esutil.onepasswordStore() +
               es.spec.withData([
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
          name: 'grafana-agent-traces',
          namespace: 'monitoring',
          configMapName: 'grafana-agent-traces-config',
          envSecretName: 'grafana-agent-traces-env',
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
