(import 'handbook/main.libsonnet') +
{
  _images+:: {
    handbook: {
      handbook: 'ghcr.io/panda-den/handbook:23.6.29-c7b8703',
    },
  },
  _config+:: {
    handbook+: {
      host: 'handbook.colorful-pandas.com',
    },
  },
}
