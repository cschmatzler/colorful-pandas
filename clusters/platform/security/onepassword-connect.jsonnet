(import 'onepassword-connect/main.libsonnet') +
{
  _config+:: {
    onepassword_connect+: {
      namespace: 'security',
      secretName: 'onepassword',
    },
  },
}
