local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.27/main.libsonnet',
      util = (import 'util.libsonnet').withK(k),
      deployment = k.apps.v1.deployment,
      container = k.core.v1.container,
      envVar = k.core.v1.envVar,
      envFromSource = k.core.v1.envFromSource,
      port = k.core.v1.containerPort;

{
  colorfulPandas+: {
    vars:: {
      port: 4000,
    },

    container::
      container.new('colorful-pandas', $._images.colorfulPandas.colorfulPandas) +
      container.withEnv([
        envVar.fromFieldPath('POD_IP', 'status.podIP'),
        envVar.new('HOST', $._config.colorfulPandas.host),
        envVar.new('PORT', std.toString(self.vars.port)),
      ]) +
      container.withEnvFrom([
        envFromSource.secretRef.withName($._config.colorfulPandas.envSecretName),
      ]) +
      container.withPorts([
        port.newNamed(self.vars.port, 'http'),
      ]),

    deployment: deployment.new(
                  'colorful-pandas',
                  replicas=3,
                  containers=[
                    self.container,
                  ]
                ) +
                util.deployment.withCommonLabels({
                  'app.kubernetes.io/name': 'colorful-pandas',
                  'app.kubernetes.io/instance': 'colorful-pandas',
                }),
  },
}
