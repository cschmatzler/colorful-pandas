local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  values:: {
    networking: {
      enabled: true,
      network: {
        valueFrom: {
          secretKeyRef: {
            name: "hcloud-network",
            key: "network",
          },
        },
      },
    },
  },

  hcloud_ccm: helm.template('hcloud-ccm', './charts/hcloud-cloud-controller-manager', {
    namespace: $._config.hcloud_ccm.namespace,
    values: $.values,
  }),
}
