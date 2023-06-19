(import 'onepassword-connect/main.libsonnet') +
{
  _config+:: {
    external_secrets+: {
      namespace: 'security',
    },
  },
}
