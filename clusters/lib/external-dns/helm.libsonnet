local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  externalDNS+: {
    values:: {
      provider: 'cloudflare',
      extraArgs: [
        '--source=ingress',
      ],
      env: [
        {
          name: 'CF_API_TOKEN',
          valueFrom: {
            secretKeyRef: {
              name: $._config.externalDNS.cloudflareSecretName,
              key: $._config.externalDNS.cloudflareSecretKey,
            },
          },
        },
      ],
    },

    template: helm.template('external-dns', '../charts/external-dns', {
      namespace: $._config.externalDNS.namespace,
      values: $.externalDNS.values,
    }),
  },
}
