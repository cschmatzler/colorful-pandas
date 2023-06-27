{ eslib: import 'github.com/jsonnet-libs/external-secrets-libsonnet/0.8/main.libsonnet' } +
{
  esutil: {
    onepasswordStore()::
      local es = $.eslib.nogroup.v1beta1.externalSecret;
      es.spec.secretStoreRef.withKind('ClusterSecretStore') +
      es.spec.secretStoreRef.withName('onepassword'),

    data(secretKey, remoteKey, remoteProperty)::
      local es = $.eslib.nogroup.v1beta1.externalSecret;
      es.spec.data.withSecretKey(secretKey) +
      es.spec.data.remoteRef.withKey(remoteKey) +
      es.spec.data.remoteRef.withProperty(remoteProperty),
  },
}
