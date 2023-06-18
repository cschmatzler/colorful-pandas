(import 'hcloud-ccm/main.libsonnet') +
{
  _config+:: {
    hcloud_ccm+: {
      namespace: 'kube-system',
    },
  },
}
