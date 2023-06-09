local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet',
      clusterRoleBinding = k.rbac.v1.clusterRoleBinding,
      subject = k.rbac.v1.subject;
{
  hcloud_csi+: {
    clusterRoleBinding: clusterRoleBinding.new(
                          name=$._config.hcloud_csi.name
                        ) +
                        clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
                        clusterRoleBinding.roleRef.withKind('ClusterRole') +
                        clusterRoleBinding.roleRef.withName($._config.hcloud_csi.name) +
                        clusterRoleBinding.withSubjects([
                          subject.withKind('ServiceAccount') +
                          subject.withName($._config.hcloud_csi.name),
                        ]),
  },
}
