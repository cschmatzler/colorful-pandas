local util(k) = {
  service: {
    ingressFor(service, ingressClassName, host, port, tlsIssuer='letsencrypt')::
      local ingress = k.networking.v1.ingress;
      ingress.new(service.metadata.name) +
      ingress.metadata.withAnnotations({
        'cert-manager.io/cluster-issuer': tlsIssuer,
        'ingress.kubernetes.io/force-ssl-redirect': 'true',
        'projectcontour.io/websocket-routes': '/'
      }) +
      ingress.spec.withIngressClassName(ingressClassName) +
      ingress.spec.withTls([
        {
          secretName: service.metadata.name + '-tls',
          hosts: [
            host,
          ],
        },
      ]) +
      ingress.spec.withRules([
        {
          host: host,
          http: {
            paths: [
              {
                pathType: 'Prefix',
                path: '/',
                backend: {
                  service: {
                    name: service.metadata.name,
                    port: {
                      name: port,
                    },
                  },
                },
              },
            ],
          },
        },
      ]),
  },

  deployment: {
    withCommonLabels(labels)::
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
  },
};

{
  withK(k)::
    util(k),
}
