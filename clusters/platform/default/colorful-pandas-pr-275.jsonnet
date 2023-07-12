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
          colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:pr-275-69c7fbcc02c2ace507679c796adbb0a8361bfb0b',
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
