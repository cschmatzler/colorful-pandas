{
  _config+:: {
    grafanaAgent: {
      name: 'grafana-agent',
      namespace: 'monitoring',
      configMapName: error 'configMapName is required',
      envSecretName: '',
      manageCRDs: true,
      extraValues: {}
    },
  },
}
