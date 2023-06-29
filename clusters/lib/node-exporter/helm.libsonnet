local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  nodeExporter+: {
    values:: {},

    template: helm.template('prometheus-node-exporter', '../charts/prometheus-node-exporter', {
      namespace: $._config.nodeExporter.namespace,
      values: $.nodeExporter.values,
    }),
  },
}
