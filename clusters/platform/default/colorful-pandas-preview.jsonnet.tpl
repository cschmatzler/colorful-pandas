{
  vars+:: {
    prNumber: {{ .Env.PR_NUMBER }}
  },
} +
{
  colorfulPandasPR{{ .Env.PR_NUMBER }}:
    (import 'colorful-pandas/main.libsonnet') +
    {
      _images+:: {
        colorfulPandas: {
          colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:{{ .Env.TAG }}',
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
