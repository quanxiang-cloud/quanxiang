<p align="center">
  <a href="https://quanxiang.dev" target="blank"><img src="https://qxp-public.pek3b.qingstor.com/qxp_vertical_logo.svg" width="300" alt="Quanxiang Cloud Logo" /></a>
</p>
<p align="center">
  <br/>
  <a href="https://quanxiang.dev" target="blank">
    QuanXiang
  </a>
</p>
<p align="center">
  <b>QuanXiang is a powerful, pluggable open source low-code platform.</b>
</p>


> English| [中文](./README_zh.md)

[![](https://img.shields.io/badge/Roadmap-QuanXiang-orange.svg)](https://github.com/quanxiang-cloud/website/tree/main/content/en/roadmap)
[![](https://img.shields.io/badge/Content-Blog-blue.svg)]()
[![](https://img.shields.io/badge/release-1.1.0-brightgreen.svg)](https://github.com/quanxiang-cloud/quanxiang/releases/tag/v1.1.0)
[![GitHub contributors](https://img.shields.io/github/contributors/quanxiang-cloud/quanxiang)](https://github.com/quanxiang-cloud/quanxiang/graphs/contributors)
[![GitHub issues](https://img.shields.io/github/issues/quanxiang-cloud/quanxiang)](https://github.com/quanxiang-cloud/quanxiang/issues)
[![GitHub stars](https://img.shields.io/github/stars/quanxiang-cloud/quanxiang.svg?style=social&label=Stars)](https://github.com/quanxiang-cloud/quanxiang)
[![GitHub forks](https://img.shields.io/github/forks/quanxiang-cloud/quanxiang.svg?style=social&label=Fork)](https://github.com/quanxiang-cloud/quanxiang)
[![Twitter Follow](https://img.shields.io/twitter/follow/QuanXiang5?style=social)](https://twitter.com/QuanXiang5)


<div align="center">
  <h3>
    Website
    <span> | </span>
    Demo
    <span> | </span>
    Documentation
    <span> | </span>
    Guide
    <span> | </span>
    <a href="https://github.com/quanxiang-cloud/quanxiang/discussions" target="_blank">Community</a>
  </h3>
</div>



## Introduction

QuanXiang is a cloud-native, fully containerized, open source, low-code platform used to assist in building various types of digital applications for enterprises. The platform currently provides two application development modes: no-code and low-code on the cloud, and supports visual design, allowing developers and business users to quickly complete application development through simple drag-and-drop and parameter configuration. As a multi-application integration and management platform integrating low-code development capability, identity authentication capability and container DevOps capability, QuanXiang supports rapid application building, easy maintenance and management of applications, integration of enterprise stock business and full-image cloud building business.


## Features

QuanXiang builds a low-code ecosystem around application design, development, deployment, operation and maintenance. The core capabilities of the platform are as follows:

<details>
  <summary><b> 🚀 Rapid application development</b></summary>
  <li>Visual designer: Users can complete form, workflow, data_models, and permissions through simple drag and drop, parameter configuration, etc.
  <li>Form engine: Provides rich page components.
  <li>Workflow engine: Supports a variety of triggering methods and process components, and provides the ability of a rule engine to meet the logic definitions of complex businesses.
  </details>

<details>
  <summary><b>☁️ Cloud deployment operation and maintenance</b></summary>
  <li>QuanXiang is based on Kubernetes deployment, CI/CD continuous delivery deployment.
  <li>Support the deployment and operation and maintenance of different cloud vendors.
  <li>Provide system log, support to view all operation records.
  </details>

<details>
  <summary><b>🤖 Multi-terminal adaptation</b></summary>
  Apply one-time design and adapt flexibly to multiple ends. Support one-click publishing as WEB App, Native App, WeChat Applet.
  </details>

<details>
  <summary><b>🧑‍💻 Organization management</b></summary>
  <li>Corporate directory: Provide a variety of ways to manage the corporate directory to help companies quickly build an organization.
  <li>Role management: Enterprise role permissions are subdivided to ensure platform account access security and data security.
</details>
<details>
  <summary><b>🗂 System connectivity</b></summary>
  <li>Supports data connection between applications, providing data connection capabilities of different granularity, for example, data linkage update between tables and interaction between fields.
  <li>Provide solution integration of different granularities, such as: component integration, page integration, application integration.
  </details>


<details>
  <summary><b>🧩 Pluggable open source</b></summary>
  QuanXiang is a cloud native, distributed architecture platform system. Core services (except for aggregated services) are completely decoupled and low cohesive, and services are accessed through API interfaces.
  </details>



## Architecture

QuanXiang uses a loosely-coupled architecture that separates the frontend from the backend. It provides a plug-and-play, microservices architecture and embraces the diversity of languages and developer frameworks. The platform is divided into: application layer, docking layer, data processing layer and basic layer.

![architecture_en](./doc/images/architecture_en.png)



## Installation

QuanXiang privodes a deployment tool, which can help user to quckly deploy QuanXiangCloud low-code platform with a single line of command . QuangXiang deployment tool support most of popular K8S release, currently supported for installation in KubeSphere environments.

<details>
<summary><b>✨ Installing on a Kubesphere environment (recommended)</b></summary>

### Prerequisites

- Kubernetes cluster environment  v1.21.*
- OpenFunction v0.6.0
- MetalLb  v0.13.7 (*optional*)

### Deploy QuanXiang on KubeShpere(recommend)

#### Prerequisite

Before deploying QuanXiang, below options are required in local environment:

- Accessible KubeSphere cluster.
- 'kubectl' is installed on local. refer [kubectl installation](https://kubernetes.io/docs/tasks/tools/) to install kubectl.
- Kubeconfig is configured. refer below steps to configure kubeconfig
  - Get QKE kubeconfig from QingCloud console.
  - For KubeSphere kubeconfig, refer to [documentation](https://kubernetes.io/docs/tasks/tools/) or ask [community](https://github.com/kubesphere) for more help.
- Helm3 is required. refer [helm3 installation](https://helm.sh/docs/intro/install/) to install helm3.

#### Step 1. Deploy KubeSphere and Openfunction

##### KubeSphere

- Deploy KubeSphere manully, refer [office documentation](https://kubesphere.io/docs/) for more details.
- Using [KubeSphere(R)（QKE） ](https://docsv3.qingcloud.com/container/qke/)(recommend) to deploy KubeShere cluster, which is high availability and support automatic inspection and repair.

KubeSphere cluster requirments:

| Node Type | Quantity | Resource Requirment                    |
| --------- | -------- | -------------------------------------- |
| Master    | 1        | CPU: 4 core, Memory: 8 GB, Disk: 80 GB |
| Worker    | 5        | CPU: 4 core, Memory: 8 GB, Disk: 80 GB |


> **Notice**
>
> Scale nodes' resources to double and use PaaS that privode by cloud vendors, if you want to use QuanXiang as production.

##### OpenFunction

Deploy Openfunction manully, refer [office documentation](https://openfunction.dev/docs/getting-started/installation/)

- Deploy OpenFunction with helm:

```
kubectl create namespace openfunction
helm repo add openfunction https://openfunction.github.io/charts/
helm update
helm install openfunction openfunction/openfunction --version 0.1.0 -n openfunction
```

#### Step 2 Deploy MetalLB (Optional)

Persistence IP address is recommended, that is easily to access QuanXiang web site. Before you deploy MetalLB,  you should prepare several  IP addresses which should  be available.  Refer [official documentation](https://metallb.universe.tf/installation/) to more information about installation.

- Following step is copied from MetalLB official web site. 

If you’re using kube-proxy in IPVS mode, since Kubernetes v1.14.2 you have to enable strict ARP mode.

*Note, you don’t need this if you’re using kube-router as service-proxy because it is enabling strict ARP by default.*

You can achieve this by editing kube-proxy config in current cluster:

```bash
kubectl edit configmap -n kube-system kube-proxy
```

and set:

```yaml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true
```

- Deploy MetalLB with helm:

```
helm repo add metallb https://metallb.github.io/metallb
helm repo update
helm install metallb metallb/metallb -n metallb-system --create-namespace
```

- Assign IP pool  to Kubernetes from file ip-pool.yaml, 

```
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: lowcode
  namespace: metallb-system
spec:
  addresses:
  - 192.168.208.190-192.168.208.195  # replace this to your ips
```

>**Notice**
>
>Those IP address must be accessable and available to use.
>
>

- Apply the IP Pools by "kubectl apply".

```
kubectl apply -f ip-pool.yaml
```

#### Step 3. QuanXiang installation

**Helm Charts installation is enabled after v2.0.0.**

##### Download release

You can download the [release version](https://github.com/quanxiang-cloud/quanxiang/releases/tag/v1.1.0) directly or clone the source code from github.

```bash
 git clone https://github.com/quanxiang-cloud/quanxiang.git
```

#### Deploy QuanXiang

QuanxiangCloud deployment tool support production and demo:

- For production, database, cache, message etc. should be installed before you deploy QuanXiang, refer [configurations](https://github.com/quanxiang-cloud/quanxiang/blob/master/doc/install.md#Configurations) for more details.
- For demo, all services will be deployed in Kubernetes.

##### Configurations

For production, you cat set `enable` to `false` to disable middle services in configuration file `quanxiang/values.yaml` . refer to notes in values file for more details.

```bash
# Default values for quanxiang.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

#replicaCount: 1

global:
  namespace: ""
  domain: example.com                  # replace value to your domain. 修改成您自己的域名。
  websocket_hostname: ws.example.com   # socket server访问地址
  home_hostname: home.example.com     # 用户端访问地址
  portal_hostname: portal.example.com  # 管理端访问地址
  vendor:
    protocol: http                 # 前端渲染配置访问协议。
    hostname: vendors.example.com      # 前端渲染配置访问地址。
    port: 80                       # 前端渲染配置端口。
  faas:
    enabled: true                  # 是否安装faas。
  loadBalancer: &lb
     loadBalancerIP:  '192.168.208.190' # DONNOT CHAGE  &lbIP, 不要修改 &lbIP  ---此处填写LB的可用地址,如果使用了MetalLB，在定义的IP pool里的可用地址。

hostAliases: &hostAliases
  enabled: true                # 没有可用的DNS服务做解析时，需要将此处设置为true，配置容器内hosts文件。
  <<: *lb                      # DONNOT CHAGE THIS LINE, 不要修改此行
  hostnames:
    - 'qxp-static.fs.example.com'
    - 'default.fs.example.com'  
              .....
```

##### Installation

Run `helm install` to install QuanXiang:

```bash
cd quanxiang/deployment/charts
helm install lowcode -n lowcode ./quanxiang --create-namespace --timeout 1800s
```

##### Uninstall

```bash
helm uninstall lowcode -n lowcode
```
</details>

#### How to access

##### Configure gateway

Refer [KubeSphere official documentation](https://kubesphere.io/docs/project-administration/project-gateway/) to configure gateway if you do not use MetalLB or OpenELB. LoadBalancer is recommend.

##### Access QuanXiang

To access QuanxiangCloud console, you should configure your hosts file or add dns records into dns server. Use default admin user and password `admin@quanxiang.dev/654321a..` to login.

- Go to http://portal.example.com to access QuanxiangCloud administration console.
- Go to http://home.example.com to access QuanxiangCloud client console.

> **Notice**
>
> Refer [KubeSphere office documentation](https://kubesphere.io/zh/docs/project-user-guide/application-workloads/routes/) to customize the domain.

##### initialize web configurations

**Below step is necessary if some menu is lost.**

Portal console does not initialize after installation, follow below steps to initialize:
>
> 1. Open QuanXiangCloud portal console by browser.
> 2. Open "Developer tool" in browser. MacOS  shortcut is "Option + command + I", Windows/Linux shortcut is "F12" or "Control + Alt + I"
> 3. Find "Sources" in "Developer tool" and chose "Snippets".
> 4. click "New snippet" and Paste scripts content one by one
>  **notice: scripts files' path is GITROOTDIR/deployment/scripts/**

Details please refer to the image:
![snippets](./doc/images/initialize_configuration.png)



## Get Started using QuanXiang

See our [Getting Started](https://quanxiang.dev/quickstart/app_modeling/) guide over in our docs.

## Component Open Source Project

|  Service   | Function  | Planned open source date |
|  ----  | ---- | ---- |
| [structor](https://github.com/quanxiang-cloud/structor) | It's a abstract layer between bussiness layer and database, that will make users easy to use database without database knowledge.  | 2022/5/17 |
| process | Process engine kernel: process model definition, process scheduling and instance data logging. | 2022/6/6 |
| persona | Application Configuration Center: Application personalized configuration data storage. | 2022/7/1 |
| kms | Key management: platform key management and signature verification, external key proxy and authentication. | To be determined |

## Interaction

- 💬 [Twitter](https://twitter.com/QuanXiang5)
- 🤖 [Slack Channel](https://quanxiangcloud.slack.com/join/shared_invite/zt-17p7ne6h3-WtDNV72vnQ0vl8pdeLxABg)
- 🙌 [Forum](https://github.com/quanxiang-cloud/quanxiang/discussions)

