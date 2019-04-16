# logstash5


```console
$ helm install yonyouccs/logstash5
```

## Introduction

This chart bootstraps a [elasticsearch] deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.10+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release yonyouccs/logstash5
```

The command deploys logstash5 on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Tomcat chart and their default values.

|           Parameter           |                 Description                  |                           Default                         |
|-------------------------------|----------------------------------------------|---------------------------------------------------------- |
| `image.registry`              | Tomcat image registry                        | `docker.io`                                               |
| `image.repository`            | Tomcat Image name                            | `yonyouccs/logstash5`                                          |
| `image.tag`                   | Tomcat Image tag                             | `{VERSION}`                                               |
| `image.pullPolicy`            | Tomcat image pull policy                     | `Always` if `imageTag` is `latest`, else `IfNotPresent`   |
| `image.pullSecrets`           | Specify image pull secrets                   | `nil` (does not add image pull secrets to deployed pods)  |
| `serviceType`                 | Kubernetes Service type                      | `LoadBalancer`                                            |
| `persistence.enabled`         | Enable persistence using PVC                 | `true`                                                    |
| `persistence.storageClass`    | PVC Storage Class for Tomcat volume          | `nil` (uses alpha storage class annotation)               |
| `persistence.accessMode`      | PVC Access Mode for Tomcat volume            | `ReadWriteOnce`                                           |
| `persistence.size`            | PVC Storage Request for Tomcat volume        | `8Gi`                                                     |
| `resources`                   | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                              |

