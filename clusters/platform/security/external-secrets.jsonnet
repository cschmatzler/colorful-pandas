(import 'external-secrets/main.libsonnet') +
{
  _config+:: {
    external_secrets+: {
      namespace: 'security',
    },
  },
} +
{
  local es = import 'es.libsonnet',
  local css = es.nogroup.v1beta1.clusterSecretStore,
  external_secrets+: {
    clusterSecretStores: {
      onepassword: css.new('onepassword') +
                   // TODO: Don't hardcode this
                   css.spec.provider.onepassword.withConnectHost('http://onepassword-connect.security.svc.cluster.local:8080') +
                   css.spec.provider.onepassword.withVaults({ 'Colorful Pandas': 1 }) +
                   // TODO: Don't hardcode this
                   css.spec.provider.onepassword.auth.secretRef.connectTokenSecretRef.withName('onepassword') +
                   css.spec.provider.onepassword.auth.secretRef.connectTokenSecretRef.withNamespace('security') +
                   css.spec.provider.onepassword.auth.secretRef.connectTokenSecretRef.withKey('token'),
    },
  },
}
