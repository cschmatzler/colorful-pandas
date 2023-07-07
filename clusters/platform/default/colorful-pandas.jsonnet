{
  vars+:: {
    envSecretName: 'colorful-pandas-env',
  },
} +
// ExternalSecret
{
  local eslib = (import 'external-secrets.libsonnet').eslib,
  local esutil = (import 'external-secrets.libsonnet').esutil,
  local es = eslib.nogroup.v1beta1.externalSecret,
  colorfulPandas+: {
    externalSecrets+: {
      config: es.new($.vars.envSecretName) +
              esutil.onepasswordStore() +
              es.spec.withData([
                esutil.data('DB_URL', 'Neon main', 'url'),
                esutil.data('SECRET_KEY_BASE', 'Colorful Pandas', 'SECRET_KEY_BASE'),
                esutil.data('LIVEVIEW_SIGNING_SALT', 'Colorful Pandas', 'LIVEVIEW_SIGNING_SALT'),
                esutil.data('HONEYCOMB_API_KEY', 'Colorful Pandas', 'HONEYCOMB_API_KEY'),
                esutil.data('HONEYCOMB_DATASET', 'Colorful Pandas', 'HONEYCOMB_DATASET'),
                esutil.data('GITHUB_CLIENT_ID', 'GitHub OAuth', 'username'),
                esutil.data('GITHUB_CLIENT_SECRET', 'GitHub OAuth', 'credential'),
              ]),
    },
  },
} +
(import 'colorful-pandas/main.libsonnet') +
{
  _images+:: {
    colorfulPandas: {
      colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:23.7.7-50da159',
    },
  },
  _config+:: {
    colorfulPandas+: {
      host: 'colorful-pandas.com',
      envSecretName: $.vars.envSecretName,
    },
  },
}
