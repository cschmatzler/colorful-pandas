(import 'onepassword-connect/main.libsonnet') +
{
  _config+:: {
    onepasswordConnect+: {
      namespace: 'security',
      secretName: 'onepassword',
    },
  },
}
