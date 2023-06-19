local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  onepassword_connect: {
    values:: {
      connect: {
        credentialsName: $._config.onepassword_connect.secretName,
        credentialsKey: '1password-credentials.json',
      },
    },

    template: helm.template('onepassword-connect', '../charts/connect', {
      namespace: $._config.onepassword_connect.namespace,
      values: $.onepassword_connect.values,
      includeCrds: $._config.onepassword_connect.manageCRDs,
    }),
  },
}
