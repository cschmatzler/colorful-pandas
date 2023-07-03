(import 'handbook/main.libsonnet') +
{
  _images+:: {
    handbook: {
      handbook: 'ghcr.io/panda-den/handbook:23.7.3-725c3c2',
    },
  },
  _config+:: {
    handbook+: {
      host: 'handbook.colorful-pandas.com',
    },
  },
}
