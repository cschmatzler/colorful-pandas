(import 'cert-manager/main.libsonnet') +
{
  _config+:: {
    cert_manager+: {
      namespace: 'security',
    },
  },
}
