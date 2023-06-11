{
  _config+:: {
    cilium: {
      namespace: 'networking',
      service_host: error 'Service host is required',
      hubble_host: error 'Hubble host is required',
      hubble_dns_target: error 'Hubble DNS target is required',
      cluster_issuer: 'letsencrypt',
    },
  },
}
