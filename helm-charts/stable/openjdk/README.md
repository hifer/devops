
```console
$ helm install 17elian/openjdk
```


## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release 17elian/openjdk
```

The command deploys openjdk on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the openjdk chart and their default values.

|           Parameter           |                 Description                  |                           Default                         |
|-------------------------------|----------------------------------------------|---------------------------------------------------------- |
| `image.registry`              | openjdk image registry                        | `docker.io`                                               |
| `image.repository`            | openjdk Image name                            | `17elian/openjdk`                                          |
| `image.tag`                   | openjdk Image tag                             | `{VERSION}`                                               |
| `image.pullPolicy`            | openjdk image pull policy                     | `Always` if `imageTag` is `latest`, else `IfNotPresent`   |
| `image.pullSecrets`           | Specify image pull secrets                   | `nil` (does not add image pull secrets to deployed pods)  |
| `openjdkUsername`              | openjdk admin user                            | `user`                                                    |
| `openjdkPassword`              | openjdk admin password                        | _random 10 character alphanumeric string_                 |
| `openjdkAllowRemoteManagement` | Enable remote access to management interface | `0` (disabled)                                            |
| `serviceType`                 | Kubernetes Service type                      | `LoadBalancer`                                            |
| `persistence.enabled`         | Enable persistence using PVC                 | `true`                                                    |
| `persistence.storageClass`    | PVC Storage Class for openjdk volume          | `nil` (uses alpha storage class annotation)               |
| `persistence.accessMode`      | PVC Access Mode for openjdk volume            | `ReadWriteOnce`                                           |
| `persistence.size`            | PVC Storage Request for openjdk volume        | `8Gi`                                                     |
| `resources`                   | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set openjdkUser=manager,openjdkPassword=password 17elian/openjdk
```

The above command sets the openjdk management username and password to `manager` and `password` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml 17elian/openjdk
```

> **Tip**: You can use the default [values.yaml](values.yaml)

