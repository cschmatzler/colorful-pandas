(import 'contour/main.libsonnet') +
{
  _config+:: {
    contour+: {
      namespace: 'networking',
      ingressClass: "public",
      loadBalancerName: "contour"
    },
  },
}
