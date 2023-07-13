{
  _config+:: {
    colorfulPandas: {
      name: 'colorful-pandas',
      replicas: 3,
      host: error 'host is required',
      envSecretName: 'colorful-pandas-env',
      headlessServiceName: 'colorful-pandas-headless'
    },
  },
}
