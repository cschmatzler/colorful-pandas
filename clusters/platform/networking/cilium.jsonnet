(import 'cilium/main.libsonnet') +
{
  _config+:: {
    cilium+: {
      namespace: 'networking',
      service_host: 'cluster.platform.colorful-pandas.com',
    },
  },
}
