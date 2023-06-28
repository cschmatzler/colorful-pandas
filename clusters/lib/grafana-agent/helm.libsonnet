local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  grafanaAgent+: {
    values:: {
      controller: {
        type: $._config.grafanaAgent.type,
        replicas: $._config.grafanaAgent.replicas,
      },
      agent: {
               configMap:
                 {
                   create: false,
                   name: $._config.grafanaAgent.configMapName,
                 },
             } +
             (
               if $._config.grafanaAgent.envSecretName != '' then
                 { envFrom: [{ secretRef: { name: $._config.grafanaAgent.envSecretName } }] }
               else {}
             ),
      configReloader: {
        enabled: false,
      },
    },

    template: helm.template($._config.grafanaAgent.name, '../charts/grafana-agent', {
      namespace: $._config.grafanaAgent.namespace,
      values: std.mergePatch($.grafanaAgent.values, $._config.grafanaAgent.extraValues),
      includeCrds: $._config.grafanaAgent.manageCRDs,
    }),
  },
}
