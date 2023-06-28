(import 'handbook/main.libsonnet') +
{
  _images+:: {
    handbook: {
      handbook: 'ghcr.io/panda-den/handbook:23.6.28-5945b64',
    },
  },
  _config+:: {
    handbook+: {
      host: 'handbook.colorful-pandas.com',
    },
  },
}
