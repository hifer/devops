# Tomcat

[Apache Tomcat](http://dubbo-admin.apache.org/), often referred to as Tomcat, is an open-source web server and servlet container developed by the Apache Software Foundation. Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment for Java code to run in.

## TL;DR;

```console
$ helm install bitnami/dubbo-admin
```

## Introduction

This chart bootstraps a [Tomcat](https://github.com/bitnami/bitnami-docker-dubbo-admin) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release bitnami/dubbo-admin
```

The command deploys Tomcat on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
| `image.repository`            | Tomcat Image name                            | `bitnami/dubbo-admin`                                          |
| `image.tag`                   | Tomcat Image tag                             | `{VERSION}`                                               |
| `image.pullPolicy`            | Tomcat image pull policy                     | `Always` if `imageTag` is `latest`, else `IfNotPresent`   |
| `image.pullSecrets`           | Specify image pull secrets                   | `nil` (does not add image pull secrets to deployed pods)  |
| `dubbo-adminUsername`              | Tomcat admin user                            | `user`                                                    |
| `dubbo-adminPassword`              | Tomcat admin password                        | _random 10 character alphanumeric string_                 |
| `dubbo-adminAllowRemoteManagement` | Enable remote access to management interface | `0` (disabled)                                            |
| `serviceType`                 | Kubernetes Service type                      | `LoadBalancer`                                            |
| `persistence.enabled`         | Enable persistence using PVC                 | `true`                                                    |
| `persistence.storageClass`    | PVC Storage Class for Tomcat volume          | `nil` (uses alpha storage class annotation)               |
| `persistence.accessMode`      | PVC Access Mode for Tomcat volume            | `ReadWriteOnce`                                           |
| `persistence.size`            | PVC Storage Request for Tomcat volume        | `8Gi`                                                     |
| `resources`                   | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                              |

The above parameters map to the env variables defined in [bitnami/dubbo-admin](http://github.com/bitnami/bitnami-docker-dubbo-admin). For more information please refer to the [bitnami/dubbo-admin](http://github.com/bitnami/bitnami-docker-dubbo-admin) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set dubbo-adminUser=manager,dubbo-adminPassword=password bitnami/dubbo-admin
```

The above command sets the Tomcat management username and password to `manager` and `password` respectively.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml bitnami/dubbo-admin
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Tomcat](https://github.com/bitnami/bitnami-docker-dubbo-admin) image stores the Tomcat data and configurations at the `/bitnami/dubbo-admin` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
