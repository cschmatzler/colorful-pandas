{
  _config+:: {
    contour: {
      namespace: 'networking',
      manageCRDs: true,
      ingressClass: error 'ingressClass is required',
      loadBalancerName: error 'loadBalancerName is required',
      loadBalancerLocation: 'fsn1',
      loadBalancerType: 'lb11',
    },
  },
}
