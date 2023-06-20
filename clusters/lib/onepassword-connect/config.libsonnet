{
  _config+:: {
    onepasswordConnect: {
      namespace: 'security',
      manageCRDs: true,
      secretName: error "secretName is required"
    },
  },
}
