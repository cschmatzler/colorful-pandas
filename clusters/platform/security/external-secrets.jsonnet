(import 'external-secrets/main.libsonnet') +
{
  _config+:: {
    external_secrets+: {
      namespace: 'security',
    },
  },
}
