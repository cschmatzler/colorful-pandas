(import 'colorful-pandas/main.libsonnet') +
{
  _images+:: {
    colorfulPandas: {
      colorfulPandas: 'ghcr.io/panda-den/colorful-pandas:23.6.27-44877db',
    },
  },
  _config+:: {
    colorfulPandas+: {
      host: 'colorful-pandas.com',
    },
  },
}
