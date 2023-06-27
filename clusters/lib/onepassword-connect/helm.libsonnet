local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  onepasswordConnect+: {
    values:: {
      connect: {
        credentialsName: $._config.onepasswordConnect.secretName,
        credentialsKey: '1password-credentials.json',
      },
    },

    template: helm.template('onepassword-connect', '../charts/connect', {
      namespace: $._config.onepasswordConnect.namespace,
      values: $.onepasswordConnect.values,
      includeCrds: $._config.onepasswordConnect.manageCRDs,
    }),
  },
}
