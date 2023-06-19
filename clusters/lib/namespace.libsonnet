local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      namespace = k.core.v1.namespace;

{
  new(name, is_privileged=false)::
    namespace.new(name) +
    if is_privileged
    then namespace.metadata.withLabels({ 'pod-security.kubernetes.io/enforce': 'privileged' })
    else {},
}
