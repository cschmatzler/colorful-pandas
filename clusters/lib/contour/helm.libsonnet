local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  contour: {
    values:: {
      contour: {
        manageCRDs: $._config.contour.manageCRDs,
        ingressClass: {
          name: $._config.contour.ingressClass,
          default: true,
        },
      },
      envoy: {
        useHostPort: false,
        service: {
          annotations: {
            'load-balancer.hetzner.cloud/name': $._config.contour.loadBalancerName,
            'load-balancer.hetzner.cloud/location': $._config.contour.loadBalancerLocation,
            'load-balancer.hetzner.cloud/type': $._config.contour.loadBalancerType,
            'load-balancer.hetzner.cloud/disable-private-ingress': 'true',
            'load-balancer.hetzner.cloud/use-private-ip': 'true',
          },
        },
      },
    },

    template: helm.template('contour', '../charts/contour', {
      namespace: $._config.contour.namespace,
      values: $.contour.values,
      includeCrds: $._config.contour.manageCRDs,
    }),
  },
}
