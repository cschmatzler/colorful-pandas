local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  externalDNS+: {
    values:: {
      
    },

    template: helm.template('external-dns', '../charts/external-dns', {
      namespace: $._config.externalDNS.namespace,
      values: $.externalDNS.values,
      includeCrds: true,
    }),
  },
}
