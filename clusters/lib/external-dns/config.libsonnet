{
  _config+:: {
    externalDNS: {
      namespace: 'networking',
      cloudflareSecretName: error 'cloudflareSecretName is required',
      cloudflareSecretKey: error 'cloudflareSecretKey is required'
    },
  },
}
