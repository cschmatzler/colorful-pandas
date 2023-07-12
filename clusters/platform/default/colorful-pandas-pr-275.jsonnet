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
          colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:pr-275-9c7996d6cc0b545c3d4684c72688c1190c9602dd',
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
+ (import 'colorful-pandas-pr-275.jsonnet')
