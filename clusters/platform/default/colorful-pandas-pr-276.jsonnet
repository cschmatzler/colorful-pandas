{
  vars+:: {
    prNumber: 276,
    envSecretName: 'colorful-pandas-env',
  },
} +
{
  colorfulPandasPR276:
    (import 'colorful-pandas/main.libsonnet') +
    {
      _images+:: {
        colorfulPandas: {
          colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:pr-' + $.vars.prNumber,
        },
      },
      _config+:: {
        colorfulPandas+: {
          name: 'colorful-pandas-pr-' + $.vars.prNumber,
          host: 'pr-' + $.vars.prNumber + '.preview.colorful-pandas.com',
          envSecretName: $.vars.envSecretName,
        },
      },
    },
}
