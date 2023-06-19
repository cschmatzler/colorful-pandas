{
  _config+:: {
    onepassword_connect: {
      namespace: 'security',
      manageCRDs: true,
      secretName: error "secretName is required"
    },
  },
}
