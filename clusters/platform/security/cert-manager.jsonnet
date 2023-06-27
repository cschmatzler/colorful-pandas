{
  vars+:: {
    secretName: 'cert-manager-cloudflare-token',
    secretKey: 'cloudflare-token'
  }
} +
// ExternalSecret
{
  local eslib = (import 'external-secrets.libsonnet').eslib,
  local esutil = (import 'external-secrets.libsonnet').esutil,
  local es = eslib.nogroup.v1beta1.externalSecret,
  certManager+: {
    externalSecrets+: {
      cloudflareToken: es.new($.vars.secretName) +
                       esutil.onepasswordStore() +
                       es.spec.withData([
                         esutil.data($.vars.secretKey, 'Cloudflare', 'credential')
                       ]),
    },
  },
} +
// Deployment
(import 'cert-manager/main.libsonnet') +
{
  _config+:: {
    certManager+: {
      namespace: 'security',
    },
  },
} +
// ClusterIssuer
{
  local cm = import 'cert-manager.libsonnet',
  local ci = cm.nogroup.v1.clusterIssuer,
  certManager+: {
    clusterIssuers: {
      letsencrypt: ci.new('letsencrypt') +
                   ci.spec.acme.withServer('https://acme-v02.api.letsencrypt.org/directory') +
                   ci.spec.acme.privateKeySecretRef.withName('letsencrypt-key') +
                   ci.spec.acme.withSolvers([
                     ci.spec.acme.solvers.dns01.cloudflare.apiTokenSecretRef.withName($.vars.secretName) +
                     ci.spec.acme.solvers.dns01.cloudflare.apiTokenSecretRef.withKey($.vars.secretKey),
                   ]),
    },
  },
}
