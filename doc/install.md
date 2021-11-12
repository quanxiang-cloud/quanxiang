# Getting Started

## Overview

QuanxiangCloud privode a deployment tool, which can help user to quckly deploy QuanxiangCloud low-code platform with a single line of command . Quangxiang deployment tool support most of popular K8S release: 

- [Deploy QuanxiangCloud on KubeShpere](#Deploy QuanxiangCloud on KubeShpere(recommend))
- [Deploy QuanxiangCloud on Kubernetes](#Deploy QuanxiangCloud on Kubernetes)

## Prerequisites 

* Kubernetes cluster environment 

## Deploy QuanxiangCloud on KubeShpere(recommend)

### Deploy KubeSphere

There are two ways to deploy KubeSphere: 

- Deploy KubeSphere manully, refer [office documentation](!https://kubesphere.io/docs/) for more details.
- Using  [KubeSphere(R)（QKE） ](https://docsv3.qingcloud.com/container/qke/)(recommend) to deploy  KubeShere cluster, which is high availability and support automatic inspection and repair. 

 KubeSphere cluster requirments:

| Node Type | quantity | Resource Requirment                    |
| --------- | -------- | -------------------------------------- |
| Master    | 1        | CPU: 4 core, Memory: 8 GB, Disk: 80 GB |
| Worker    | 5        | CPU: 4 core, Memory: 8 GB, Disk: 80 GB |

>**Notice**
>
>Scale nodes' resources to double and use PaaS that privode by cloud vendors, if you want to use QuanxiangCloud as production.

### QuanxiangCloud installation

#### Prerequisite

Before deploying QuanxingCloud,  below options are required in local environment:

- Accessible KubeSphere cluster 
- 'kubectl' is installed on local. refer [kubectl installation](!https://kubernetes.io/docs/tasks/tools/) to install kubectl.
- Kubeconfig is configured. refer below steps to configure kubeconfig
  - Get QKE kubeconfig from QingCloud console.
  - For KubeSphere kubeconfig, refer to [documentation](!https://kubesphere.com.cn/docs/) or ask [community](!https://github.com/kubesphere) for more help.

- Helm3 is required. refer [helm3 installation](!https://helm.sh/docs/intro/install/) to install helm3.

#### Download release

You can download the  [release](!https://github.com/quanxiang-cloud/quanxiang/releases)  version directly.    **QuanxiangCloud privode various architecture package.**

#### Build from source code

To build QianxiangCloud deployment tool, that golang 1.16 is needed and special correct GOOS, GOARCH. Example  command with Linux and amd64.

```bash
 git clone https://github.com/quanxiang-cloud/quanxiang.git
 cd quanxiang
 git checkout master
 CGO_ENABLED=0 GOOS=linux GOARCH=adm64 go build -o installApp main.go
```

> Notice
>
> - GOOS: darwin, Linux, Windows, FreeBSD etc.
> - GOARCH: amd64, 386, arm etc.

#### Deploy QuanxiangCloud

QuanxiangCloud deployment tool support production and demo:

- For production,  database, cache,  message etc. should be installed, refer [configurations](#Configurations) for more details.
- For demo, all services will be deployed in Kubernetes.

###### Configurations

For production,  you cat set  `enable`  to `false` to disable middle services in configuration file `configs/configs.yml` . refer to notes in configuration file for more details. 

```bash
 vim configs/configs.yml
    #Middleware Services 中间件服务
    mysql:
      enabled: true
      rootPassword: qxp1234     #It is required to set the root user password if enabled equal to true    设置root用户密码 enabled为true时必填
    redis:
      enabled: true
      password: cXhwMTIzNA==    #The password here is the base64 code of the password. For example, the base64 code of qxp1234 is cxhwmjm0cg==  这里的password为密码的base64编码，比如qxp1234的base64编码为cXhwMjM0Cg==
    kafka:
              .....
```

###### Installation

Run  `installApp`  to install the trial version:

```
./installApp start -k ~/.kube/config  -i -n lowcode
```

Parameters description:

| parameter            | purpose                                                      | Description                                                  |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| -c/--configfile      | relative or absolute path of the configuration file          | Indicates the absolute or relative path of the current project configs / configs.yml |
| -d/--deploymentFile  | absolute or relative path of deployment folder               | absolute or relative path to the current project deployment folder |
| -k/--kubeconfig      | the profile path than can access to k8s cluster              | If the file is in the default location ~ /. Kube / config, you can not specify this parameter |
| -i/--middlerwareInit | middleware initialization                                    | If specified, perform middleware initialization              |
| -n/--namespace       | The namespace in which the service is deployed in the k8s cluster | If not specified, the default namespace is default           |

###### Uninstall

```
./installApp uninstall -k ~/.kube/config -n lowcode
```

Parameters description:

| parameter | purpose |Description  |
-------|------|----------
| -d/--deploymentFile | The path to the deployment folder  | Absolute or relative path to the current project deployment folder  |
| -k/--kubeconfig | the profile path than can access to k8s cluster  | If the file is in the default location ~ /. Kube / config, you can not specify this parameter |
| -n/--namespace | The namespace in which the service is deployed in the k8s cluster | If not specified, the default namespace is default |
| -u/--uninstallMiddlerware | Do you need to uninstall the middleware deployed by the tool | If there is no middleware deployed using this tool, you can not add this parameter. When the middleware is loaded and unloaded, it will be reported that there is no such resource and can be ignored |

#### How to access

###### Configure gateway

Refer [KubeSphere official documentation](https://kubesphere.io/docs/project-administration/project-gateway/) to configure gateway. LoadBalancer is recommend.

###### Access QuanxiangCloud

To access QuanxiangCloud console,  you should configure your hosts file or add dns records into dns server.  Use default admin user and password `Admin@Admin.com)/654321a..` to login.

Go to http://portal.qxp.com to access QuanxiangCloud administration console. 

Go to http://home.qxp.com to access QuanxiangCloud client console. 

> **Notice**
>
> refer [KubeSphere office documentation](https://kubesphere.io/zh/docs/project-user-guide/application-workloads/routes/) to customize the domain *



### Deploy QuanxiangCloud on Kubernetes

Coming Soon
