local k = import 'k.libsonnet', secret = k.core.v1.secret;

(import 'hcloud-ccm/main.libsonnet') +
{
  _config+:: {
    hcloud_ccm+: {
      namespace: 'kube-system',
    },
  },
}
