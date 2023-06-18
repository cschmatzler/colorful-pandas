{
  _config+:: {
    cilium: {
      namespace: 'networking',
      service_host: error 'Service host is required',
    },
  },
}
