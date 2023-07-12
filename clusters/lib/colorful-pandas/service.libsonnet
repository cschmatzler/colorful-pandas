local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      util = (import 'util.libsonnet').withK(k),
      service = k.core.v1.service;

{
  colorfulPandas+: {
    headlessService: service.new($._config.colorfulPandas.headlessServiceName, {
                       'app.kubernetes.io/name': $._config.colorfulPandas.name,
                       'app.kubernetes.io/instance': $._config.colorfulPandas.name,
                     }, []) +
                     service.metadata.withLabels({
                       'app.kubernetes.io/name': $._config.colorfulPandas.name,
                       'app.kubernetes.io/instance': $._config.colorfulPandas.name,
                     }) +
                     service.spec.withClusterIP('None'),

    service: util.deployment.serviceFor(self.deployment) +
             service.metadata.withLabels({
               'app.kubernetes.io/name': $._config.colorfulPandas.name,
               'app.kubernetes.io/instance': $._config.colorfulPandas.name,
             }),
  },
}
