(import 'cilium/main.libsonnet') +
{
  _config+:: {
    cilium+: {
      namespace: 'networking',
      service_host: 'cluster.prod.colorful-pandas.com',
      hubble_dns_target: 'not sure',
      hubble_host: 'hubble.prod.colorful-pandas.com',
    },
  },
}
