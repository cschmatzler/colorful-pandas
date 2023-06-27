local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  externalSecrets+: {
    template: helm.template('external-secrets', '../charts/external-secrets', {
      namespace: $._config.externalSecrets.namespace,
      includeCrds: $._config.externalSecrets.manageCRDs,
    }),
  },
}
