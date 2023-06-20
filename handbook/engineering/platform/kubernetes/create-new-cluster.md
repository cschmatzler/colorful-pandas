# Creating a new Kubernetes cluster

If you need to create a new cluster, follow these instructions.

For convenience, all commands in this section take a `$CLUSTER_NAME` environment variable. As a prerequisite, you need to set this to the new cluster's name.

::: info
The cluster name should include the full domain of the cluster.
:::

```sh
set CLUSTER_NAME staging.colorful-pandas.com
```

### Copying cluster template

Before bootstrapping a new cluster, you need to generate a few files. To help speed up that process, you can use the `_template` directory.

```sh
cp -R clusters/_template clusters/$CLUSTER_NAME
```

Many files in the new directory will have a `TODO: ` mark as comment where you will need to configure the new cluster.

### Generating Talos configuration

You also need to create the configuration files for Talos before creating any nodes:
1. Generate secrets.

    ```sh
    talosctl gen secrets -o clusters/$CLUSTER_NAME/talos/secrets.yaml
    ```

2. Generate the configuration with all patches. Please note that this command includes the patches that exist at the time of writing, and make sure to reference new ones that might have been added since.

    ```sh
    talosctl gen config \
        --with-secrets clusters/$CLUSTER_NAME/talos/secrets.yaml \
        --config-patch @clusters/$CLUSTER_NAME/talos/patches/all/cloud-provider.yaml \
        --config-patch @clusters/$CLUSTER_NAME/talos/patches/all/san.yaml \
        --config-patch @clusters/$CLUSTER_NAME/talos/patches/all/ntp.yaml \
        --config-patch-control-plane @clusters/$CLUSTER_NAME/talos/patches/control-plane/cni.yaml \
        --config-patch-worker @clusters/$CLUSTER_NAME/talos/patches/worker/sysctl.yaml \
        --talos-version $TALOS_VERSION \
        --install-image ghcr.io/siderolabs/installer:$TALOS_VERSION \
        --with-examples=false \
        --with-docs=false \
        -o clusters/$CLUSTER_NAME/talos \
        colorful-pandas-$CLUSTER_NAME \
        https://cluster.$CLUSTER_NAME:6443
    ```

    These are the CLI options:
    - `--with-secrets`: reference the secrets created in the earlier step
    - `--config-patch`, `--config-patch-control-plane`, `--config-patch-worker`: apply configuration patches during generation
    - `--talos-version`, `--install-image`: set the Talos version to install
    - `--with-examples`: don't generate any examples
    - `--with-docs`: don't add any documentation comments
    - `-o`: set output directory

    During node creation, Terraform passes the configuration as `cloud-init` data, which has a limited file size. As such, the configuration needs to exclude examples and documentation.

3. Make sure to encrypt the generated files.

    ```sh
    just encrypt-cluster-config $CLUSTER_NAME
    ```
