local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet',
      clusterRole = k.rbac.v1.clusterRole,
      policyRule = k.rbac.v1.policyRule;
{
  hcloud_csi+: {
    clusterRole: clusterRole.new(
                   name=$._config.hcloud_csi.name
                 ) +
                 clusterRole.withRules([
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['persistentvolumes']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                     'update',
                     'patch',
                   ]),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['nodes']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                   ]),
                   policyRule.withApiGroups(['csi.storage.k8s.io']) +
                   policyRule.withResources(['csinodeinfos']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                   ]),
                   policyRule.withApiGroups(['storage.k8s.io']) +
                   policyRule.withResources(['csinodes']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                   ]),
                   policyRule.withApiGroups(['storage.k8s.io']) +
                   policyRule.withResources(['volumeattachments']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                     'update',
                     'patch',
                   ]),
                   policyRule.withApiGroups(['storage.k8s.io']) +
                   policyRule.withResources(['volumeattachments/status']) +
                   policyRule.withVerbs(['patch']),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['secrets']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                   ]),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['persistentvolumes']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                     'create',
                     'delete',
                     'patch',
                   ]),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources([
                     'persistentvolumeclaims',
                     'persistentvolumeclaims/status',
                   ]) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                     'update',
                     'patch',
                   ]),
                   policyRule.withApiGroups(['storage.k8s.io']) +
                   policyRule.withResources(['storageclasses']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                   ]),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['events']) +
                   policyRule.withVerbs([
                     'list',
                     'watch',
                     'create',
                     'update',
                     'patch',
                   ]),
                   policyRule.withApiGroups(['snapshot.storage.k8s.io']) +
                   policyRule.withResources(['volumesnapshots']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                   ]),
                   policyRule.withApiGroups(['snapshot.storage.k8s.io']) +
                   policyRule.withResources(['volumesnapshotcontents']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                   ]),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['pods']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                   ]),
                   policyRule.withApiGroups(['']) +
                   policyRule.withResources(['events']) +
                   policyRule.withVerbs([
                     'get',
                     'list',
                     'watch',
                     'create',
                     'update',
                     'patch',
                   ]),
                 ]),
  },
}
