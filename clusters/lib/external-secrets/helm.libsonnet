local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  external_secrets: {
    values:: {
    },

    template: helm.template('external-secrets', '../charts/external-secrets', {
      namespace: $._config.external_secrets.namespace,
      values: $.external_secrets.values,
      includeCrds: $._config.external_secrets.manageCRDs,
    }),
  },
}
