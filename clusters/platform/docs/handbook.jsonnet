(import 'handbook/main.libsonnet') +
{
  _images+:: {
    handbook: {
      handbook: 'ghcr.io/cschmatzler/handbook:23.6.20-1281c6c',
    },
  },
  _config+:: {
    handbook+: {
      host: 'handbook.colorful-pandas.com',
    },
  },
}
