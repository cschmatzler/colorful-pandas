(import 'cert-manager/main.libsonnet') +
{
  _config+:: {
    certManager+: {
      namespace: 'security',
    },
  },
} +
{
  local eslib = (import 'external-secrets.libsonnet').eslib,
  local esutil = (import 'external-secrets.libsonnet').esutil,
  local es = eslib.nogroup.v1beta1.externalSecret,
  certManager+: {
    externalSecrets+: {
      cloudflareToken: es.new('cert-manager-cloudflare-token') +
                       esutil.onepasswordStore() +
                       es.spec.withData([
                         es.spec.data.withSecretKey('cloudflare-token') +
                         es.spec.data.remoteRef.withKey('Cloudflare') +
                         es.spec.data.remoteRef.withProperty('credential'),
                       ]),
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
                   ci.spec.acme.withSolvers([
                     ci.spec.acme.solvers.dns01.cloudflare.apiTokenSecretRef.withName('cert-manager') +
                     ci.spec.acme.solvers.dns01.cloudflare.apiTokenSecretRef.withKey('cloudflare-token'),
                   ]),
    },
  },
}
