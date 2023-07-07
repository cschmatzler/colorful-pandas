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

    containerEnv::
      container.withEnv([
        envVar.fromFieldPath('POD_IP', 'status.podIP'),
        envVar.new('SERVICE_NAME', $._config.colorfulPandas.headlessServiceName),
        envVar.new('HOST', $._config.colorfulPandas.host),
        envVar.new('PORT', std.toString(self.vars.port)),
        envVar.new('ENABLE_TELEMETRY', 'true'),
        envVar.new('OTLP_ENDPOINT', 'http://grafana-agent-traces.monitoring.svc.cluster.local:4318')
      ]) +
      container.withEnvFrom([
        envFromSource.secretRef.withName($._config.colorfulPandas.envSecretName),
      ]),

    migration_container::
      container.new('migrations', $._images.colorfulPandas.colorfulPandas) +
      container.withCommand('/colorful-pandas/bin/migrate') +
      self.containerEnv,

    container::
      container.new('server', $._images.colorfulPandas.colorfulPandas) +
      self.containerEnv +
      container.withPorts([
        port.newNamed(self.vars.port, 'http'),
      ]),

    deployment: deployment.new('colorful-pandas') +
                util.deployment.withCommonLabels({
                  'app.kubernetes.io/name': 'colorful-pandas',
                  'app.kubernetes.io/instance': 'colorful-pandas',
                }) +
                deployment.spec.withReplicas(3) +
                deployment.spec.template.metadata.withLabelsMixin({"grafana-agent/collect-logs": "true"}) +
                deployment.spec.template.spec.withInitContainers([self.migration_container]) +
                deployment.spec.template.spec.withContainers([self.container]),
  },
}
