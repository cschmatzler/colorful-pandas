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
    securityContext: {
      privileged: false,
      capabilities: {
        ciliumAgent: [
          'CHOWN',
          'KILL',
          'NET_ADMIN',
          'NET_RAW',
          'IPC_LOCK',
          'SYS_ADMIN',
          'SYS_RESOURCE',
          'DAC_OVERRIDE',
          'FOWNER',
          'SETGID',
          'SETUID',
        ],
        mountCgroup: [
          'SYS_ADMIN',
          'SYS_CHROOT',
          'SYS_PTRACE',
        ],
        applySysctlOverwrites: [
          'SYS_ADMIN',
          'SYS_CHROOT',
          'SYS_PTRACE',
        ],
        cleanCiliumState: [
          'NET_ADMIN',
          'SYS_ADMIN',
          'SYS_RESOURCE',
        ],
      },
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
    agent: false,
    hubble: {
      enabled: false,
    },
  },

  cilium: helm.template('cilium', '../charts/cilium', {
    namespace: $._config.cilium.namespace,
    values: $.values,
    includeCrds: true,
  }),
}
