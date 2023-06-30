(import 'handbook/main.libsonnet') +
{
  _images+:: {
    handbook: {
      handbook: 'ghcr.io/panda-den/handbook:23.6.30-b9a973',
    },
  },
  _config+:: {
    handbook+: {
      host: 'handbook.colorful-pandas.com',
    },
  },
}
