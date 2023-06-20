local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  hcloudCCM: {
    values:: {
      networking: {
        enabled: true,
        network: {
          valueFrom: {
            secretKeyRef: {
              name: 'hcloud-network',
              key: 'network',
            },
          },
        },
      },
    },

    template: helm.template('hcloud-ccm', '../charts/hcloud-cloud-controller-manager', {
      namespace: $._config.hcloudCCM.namespace,
      values: $.hcloudCCM.values,
    }),
  },
}
