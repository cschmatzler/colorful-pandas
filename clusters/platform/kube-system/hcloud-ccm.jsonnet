(import 'hcloud-ccm/main.libsonnet') +
{
  _config+:: {
    hcloudCCM+: {
      namespace: 'kube-system',
    },
  },
}
