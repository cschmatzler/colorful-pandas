local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  values:: {
    k8sServiceHost: $._config.cilium.service_host,
    k8sServicePort: 6443,
    kubeProxyReplacement: 'disabled',
    cgroup: {
      autoMount: {
        enabled: false,
      },
      hostRoot: '/sys/fs/cgroup',
    },
    loadBalancer: {
      algorithm: 'maglev',
    },
    prometheus: {
      enabled: true,
    },
    operator: {
      enabled: true,
      prometheus: {
        enabled: true,
      },
    },
    hubble: { enabled: false },
  },

  cilium: helm.template('cilium', './charts/cilium', {
    namespace: $._config.cilium.namespace,
    values: $.values,
  }),
}
