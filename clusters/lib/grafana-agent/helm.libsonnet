local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  grafanaAgent+: {
    values:: {},

    template: helm.template('grafana-agent', '../charts/grafana-agent', {
      namespace: $._config.grafanaAgent.namespace,
      values: $.grafanaAgent.values,
    }),
  },
}
