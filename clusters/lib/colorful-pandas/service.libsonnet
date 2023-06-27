local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      util = (import 'util.libsonnet').withK(k),
      service = k.core.v1.service;

{
  colorfulPandas+: {
    headlessService: service.new($._config.colorfulPandas.headlessServiceName, {
                       'app.kubernetes.io/name': 'colorful-pandas',
                       'app.kubernetes.io/instance': 'colorful-pandas',
                     }, []) +
                     service.metadata.withLabels({
                       'app.kubernetes.io/name': 'colorful-pandas',
                       'app.kubernetes.io/instance': 'colorful-pandas',
                     }) +
                     service.spec.withClusterIP('None'),

    service: util.deployment.serviceFor(self.deployment) +
             service.metadata.withLabels({
               'app.kubernetes.io/name': 'colorful-pandas',
               'app.kubernetes.io/instance': 'colorful-pandas',
             }),
  },
}
