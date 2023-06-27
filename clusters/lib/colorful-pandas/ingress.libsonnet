local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      util = (import 'util.libsonnet').withK(k);

{
  colorfulPandas+: {
    ingress: util.service.ingressFor(
      self.service,
      ingressClassName='public',
      host=$._config.colorfulPandas.host,
      port='colorful-pandas-http'
    ),
  },
}
