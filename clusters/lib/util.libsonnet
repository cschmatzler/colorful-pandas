local util(k) = {
  withDeploymentLabels(labels)::
    local deployment = k.apps.v1.deployment;
    deployment.metadata.withLabels(labels) +
    deployment.spec.selector.withMatchLabels(labels) +
    deployment.spec.template.metadata.withLabels(labels),

  serviceFor(deployment, nameFormat='%(container)s-%(port)s')::
    local container = k.core.v1.container;
    local service = k.core.v1.service;
    local servicePort = k.core.v1.servicePort;

    local ports = [
      servicePort.newNamed(
        '%(container)s-%(port)s' % { container: c.name, port: p.name },
        port=p.containerPort,
        targetPort=p.containerPort
      )
      for c in deployment.spec.template.spec.containers
      for p in (c + container.withPortsMixin([])).ports
    ];
    local selector = {
      [x]: deployment.spec.selector.matchLabels[x]
      for x in std.objectFields(deployment.spec.selector.matchLabels)
    };

    service.new(
      deployment.metadata.name,
      selector,
      ports,
    ) +
    service.metadata.withLabelsMixin({ name: deployment.metadata.name }),
};

{
  withK(k):: util(k),
}
