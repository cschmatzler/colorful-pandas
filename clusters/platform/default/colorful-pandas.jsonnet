(import 'colorful-pandas/main.libsonnet') +
{
  _images+:: {
    colorfulPandas: {
      colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:23.6.27-12746ab',
    },
  },
  _config+:: {
    colorfulPandas+: {
      host: 'colorful-pandas.com',
    },
  },
}
