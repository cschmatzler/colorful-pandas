local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      util = (import 'util.libsonnet').withK(k);

{
  handbook+: {
    ingress: util.service.ingressFor(
      self.service,
      ingressClassName='public',
      host=$._config.handbook.host,
      port='handbook-http'
    ),
  },
}
