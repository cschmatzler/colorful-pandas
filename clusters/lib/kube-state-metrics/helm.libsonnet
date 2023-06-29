local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  kubeStateMetrics+: {
    values:: {},

    template: helm.template('kube-state-metrics', '../charts/kube-state-metrics', {
      namespace: $._config.kubeStateMetrics.namespace,
      values: $.kubeStateMetrics.values,
    }),
  },
}
