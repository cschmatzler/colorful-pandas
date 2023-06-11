local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  values:: {
    installCRDs: true,
    clusterResourceNamespace: 'security',
    replicaCount: 3,
    extraArgs: [
      '--dns01-recursive-nameservers=1.1.1.1:53,9.9.9.9:53',
      '--dns01-recursive-nameservers-only',
    ],
    podDnsPolicy: 'None',
    podDnsConfig: {
      nameservers: [
        '1.1.1.1',
        '9.9.9.9',
      ],
    },
    webhook: {
      replicaCount: 3,
    },
    cainjector: {
      replicaCount: 3,
    },
  },

  cert_manager: helm.template('cert-manager', './charts/cert-manager', {
    namespace: $._config.cert_manager.namespace,
    values: $.values,
  }),
}
