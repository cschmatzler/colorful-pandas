{
  vars+:: {
    prNumber: 275
  },
} +
{
  colorfulPandasPR275:
    (import 'colorful-pandas/main.libsonnet') +
    {
      _images+:: {
        colorfulPandas: {
          colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:pr-275-${GITHUB_SHA::7}',
        },
      },
      _config+:: {
        colorfulPandas+: {
          name: 'colorful-pandas-pr-' + $.vars.prNumber,
          host: 'pr-' + $.vars.prNumber + '.preview.colorful-pandas.com',
          envSecretName: 'colorful-pandas-env',
          headlessServiceName: 'colorful-pandas-pr-' + $.vars.prNumber + '-headless'
        },
      },
    },
}
