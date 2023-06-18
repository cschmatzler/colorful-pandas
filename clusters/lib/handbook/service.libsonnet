local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet',
      util = (import 'util.libsonnet').withK(k),
      service = k.core.v1.service;

{
  handbook+: {
    service: util.serviceFor(self.deployment) +
             service.metadata.withLabels({
               'app.kubernetes.io/name': 'handbook',
               'app.kubernetes.io/instance': 'handbook',
             }),
  },
}