local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      ingress = k.networking.v1.ingress;

{
  handbook+: {
    ingress: ingress.new('handbook') +
             ingress.metadata.withAnnotations({
               'cert-manager.io/cluster-issuer': 'letsencrypt',
               'ingress.kubernetes.io/force-ssl-redirect': 'true',
             }) +
             ingress.spec.withIngressClassName('public') +
             ingress.spec.withTls([
               {
                 secretName: 'handbook-tls',
                 hosts: [
                   $._config.handbook.host,
                 ],
               },
             ]) +
             ingress.spec.withRules([
               {
                 host: $._config.handbook.host,
                 http: {
                   paths: [
                     {
                       pathType: 'Prefix',
                       path: '/',
                       backend: {
                         service: {
                           name: 'handbook',
                           port: {
                             name: 'handbook-http',
                           },
                         },
                       },
                     },
                   ],
                 },
               },
             ]),
  },
}
