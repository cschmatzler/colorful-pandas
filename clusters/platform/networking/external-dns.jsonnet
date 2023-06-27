{
  vars+:: {
    secretName: 'external-dns-cloudflare-token',
    secretKey: 'cloudflare-token'
  }
} +
// ExternalSecret
{
  local eslib = (import 'external-secrets.libsonnet').eslib,
  local esutil = (import 'external-secrets.libsonnet').esutil,
  local es = eslib.nogroup.v1beta1.externalSecret,
  externalDNS+: {
    externalSecrets+: {
      cloudflareToken: es.new($.vars.secretName) +
                       esutil.onepasswordStore() +
                       es.spec.withData([
                         es.spec.data.withSecretKey($.vars.secretKey) +
                         es.spec.data.remoteRef.withKey('Cloudflare') +
                         es.spec.data.remoteRef.withProperty('credential'),
                       ]),
    },
  },
} +
// Deployment
(import 'external-dns/main.libsonnet') +
{
  _config+:: {
    externalDNS+: {
      cloudflareSecretName: $.vars.secretName,
      cloudflareSecretKey: $.vars.secretKey,
    }
  }
}
