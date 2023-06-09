local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet',
      serviceAccount = k.core.v1.serviceAccount;
{
  hcloud_csi+: {
    serviceAccount: serviceAccount.new(
      name=$._config.hcloud_csi.name
    ),
  },
}
