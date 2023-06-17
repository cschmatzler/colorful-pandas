local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet',
      deployment = k.apps.v1.deployment,
      container = k.core.v1.container,
      port = k.core.v1.containerPort;

{
  handbook+: {
    deployment: deployment.new('handbook') +
                deployment.spec.withReplicas(3) +
                deployment.spec.template.spec.withContainers([
                  container.withName('handbook') +
                  container.withImage($._images.handbook.handbook) +
                  container.withPorts([
                    port.withName('http') + port.withProtocol('TCP') + port.withContainerPort(80),
                  ]),
                ]),
  },
}
