(import 'cert-manager/main.libsonnet') +
{
  _config+:: {
    certManager+: {
      namespace: 'security',
    },
  },
} +
{
  local cm = import 'cert-manager.libsonnet',
  local ci = cm.nogroup.v1.clusterIssuer,
  certManager+: {
    clusterIssuers: {
      letsencrypt: ci.new('letsencrypt') +
                   ci.spec.acme.withServer('https://acme-v02.api.letsencrypt.org/directory') +
                   ci.spec.acme.privateKeySecretRef.withKey('letsencrypt-key') +
                   ci.spec.acme.solvers.dns01.cloudflare.apiTokenSecretRef.withName('cert-manager') +
                   ci.spec.acme.solvers.dns01.cloudflare.apiTokenSecretRef.withKey('cloudflare-token'),
    },
  },
}
