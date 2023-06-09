(import 'workload/hcloud-csi/hcloud-csi.libsonnet') +
{
  _config+:: {
    hcloud_csi: {
      name: 'hcloud-csi',
    },
  },
}
