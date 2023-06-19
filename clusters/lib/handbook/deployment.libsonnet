local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      util = (import 'util.libsonnet').withK(k),
      deployment = k.apps.v1.deployment,
      container = k.core.v1.container,
      port = k.core.v1.containerPort;

{
  handbook+: {
    container::
      container.new('handbook', $._images.handbook.handbook) +
      container.withPorts([
        port.newNamed(3000, 'http'),
      ]),

    deployment: deployment.new(
                  'handbook',
                  replicas=3,
                  containers=[
                    self.container,
                  ]
                ) +
                util.withDeploymentLabels({
                  'app.kubernetes.io/name': 'handbook',
                  'app.kubernetes.io/instance': 'handbook',
                }),
  },
}
