{
  _config+:: {
    grafanaAgent: {
      name: 'grafana-agent',
      namespace: 'monitoring',
      type: 'deployment',
      replicas: 2,
      configMapName: error 'configMapName is required',
      envSecretName: '',
      manageCRDs: true,
      extraValues: {}
    },
  },
}
