<p align="center">
  <a href="https://www.quanxiang.dev/" target="blank"><img src="https://qxp-public.pek3b.qingstor.com/qxp_vertical_logo.svg" width="300" alt="Quanxiang Cloud Logo" /></a>
</p>
<p align="center">
  <br/>
  <a href="https://www.quanxiang.dev/" target="blank">
    QuanXiang
  </a>
</p>
<p align="center">
  <b> QuanXiang is a powerful, pluggable open source low-code platform.</b>
</p>

----



> [English](./README.md) | 中文

[![](https://img.shields.io/badge/Roadmap-QuanXiang-orange.svg)](https://github.com/quanxiang-cloud/website/tree/main/content/zh/roadmap)
[![](https://img.shields.io/badge/Content-Blog-blue.svg)](https://github.com/quanxiang-cloud/website/tree/main/content/zh/blogs)
[![](https://img.shields.io/badge/release-1.1.0-brightgreen.svg)](https://github.com/quanxiang-cloud/quanxiang/releases/tag/v1.1.0)
[![GitHub contributors](https://img.shields.io/github/contributors/quanxiang-cloud/quanxiang)](https://github.com/quanxiang-cloud/quanxiang/graphs/contributors)
[![GitHub issues](https://img.shields.io/github/issues/quanxiang-cloud/quanxiang)](https://github.com/quanxiang-cloud/quanxiang/issues)
[![GitHub stars](https://img.shields.io/github/stars/quanxiang-cloud/quanxiang.svg?style=social&label=Stars)](https://github.com/quanxiang-cloud/quanxiang)
[![GitHub forks](https://img.shields.io/github/forks/quanxiang-cloud/quanxiang.svg?style=social&label=Fork)](https://github.com/quanxiang-cloud/quanxiang)
[![Twitter Follow](https://img.shields.io/twitter/follow/QuanXiang5?style=social)](https://twitter.com/QuanXiang5)


<div align="center">
  <h3>
    <a href="https://www.quanxiang.dev/" target="_blank">官网</a>
    <span> | </span>
    演示
    <span> | </span>
    <a href="https://docs.clouden.io/" target="_blank">文档</a>
    <span> | </span>
    <a href="https://docs.clouden.io/manual/application/new/" target="_blank">操作指南</a>
    <span> | </span>
    <a href="https://github.com/quanxiang-cloud/quanxiang/discussions" target="_blank">论坛</a>
  </h3>
</div>


## QuanXiang 是什么

**QuanXiang** 是一个基于云原生、完全容器化的开源低代码平台，用于辅助构建企业各类数字化应用。平台目前提供云上`无代码`和`低代码`两种应用开发模式，支持`可视化设计`，让开发人员和业务用户能够通过简单的拖拽、参数配置等方式快速完成应用开发。作为一个集低代码开发能力、身份认证能力、容器 DevOps 能力于一体的多应用集成和管理平台，**QuanXiang** 支持快速构建应用、便捷维护管理应用、企业存量业务及全象云构建业务的集成。



## 平台功能

QuanXiang 围绕应用设计、开发、部署、运维全生命周期管理，构建低代码生态，为企业的信息化数智化建设赋能。平台核心能力如下：

<details>
  <summary><b> 🚀 快速应用开发</b></summary>
  <li>可视化设计器：用户通过简单的拖拽、参数配置等方式就能完成页面设计、工作流编排、数据模型设计和角色权限的定义。
  <li>表单引擎：系统提供丰富的页面组件，能够满足页面呈现的自定义组件需求。
  <li>工作流引擎：包含灵活的触发方式和丰富的流程组件，支持多种触发方式，表单数据触发、时间触发、表单时间触发等。同时提供审批、填写等人为节点处理，同时支持数据新增、数据更新等自动流程节点处理。同时提供规则引擎的能力，满足复杂业务下的逻辑定义。
  </details>

<details>
  <summary><b>☁️ 多云部署和运维</b></summary>
  <li>QuanXiang 基于 Kubernetes 的容器化部署方案，CI/CD 持续交付部署，为应用的平滑部署、稳定运行保驾护航，大大降低了应用上线后迭代升级的风险和复杂度。
  <li>支持不同云厂商的部署及运维。
  <li>平台提供系统日志，支持查看所有操作记录。
  </details>

<details>
  <summary><b>🤖 多端兼容适配</b></summary>
  平台应用均可一次设计，在多端灵活适配。目前支持一键发布为 WEB 应用、Native APP、微信小程序。
  </details>
<details>
  <summary><b>🧑‍💻 灵活组织管理</b></summary>
  <li>企业通讯录：提供多种管理通讯录方式，帮助企业快速完成组织的构建。
  <li>角色管理：企业角色权限按需细分，保障平台账户访问安全和数据安全。
</details>
<details>
  <summary><b>🗂 系统连接能力</b></summary>
  <li>平台内部支持跨应用间的数据连接，提供了不同粒度的数据连接能力，包括：表与表之间的数据联动更新、字段与字段间的联动交互。
  <li>平台支持不同粒度的方案集成，包括组件集成、页面集成、应用集成。
  </details>


<details>
  <summary><b>🧩 可插拔的架构</b></summary>
  QuanXiang 是云原生、分布式架构的平台系统。各个核心服务（聚合类服务除外）采用完全解耦的、低内聚的方式设计，服务之间通过 API 接口进行访问。
  </details>


## 设计界面
🔧施工中



## 架构说明

全象云低代码平台将前端与后端分离，提供即插即用（plug-and-play）、微服务的架构，并且支持不同的开发语言、开发框架。平台分为：应用层，对接层，数据处理层及基础层。

![architecture](/doc/images/architecture.png)



## 快速安装

全象云低代码平台提供了一套快速安装程序，使用者只需一条指令即可安装全象云低代码平台，目前支持 [在 KubeSphere 环境中安装](#在Kubesphere环境中安装（推荐使用）)。

<details>
<summary><b>✨在 Kubesphere 环境中安装（推荐使用）</b></summary>

### 前提条件

- 已安装好 Kubernetes  环境 (<= v1.21.*)。
- 已安装好 OpenFunction 环境 (v0.5.0 及以上)。

#### 第 1 步：安装 KubeSphere和OpenFuction

##### KubeSPhere

安装 KubeSphere 有两种方式：

- 直接安装 KubeSphere，详细步骤参见 [官方文档](https://kubesphere.io/docs/)。
- 安装  [KubeSphere(R)（QKE） ](https://docsv3.qingcloud.com/container/qke/)（**推荐**），可以一键部署高可用的 KubeSphere 集群，并支持集群自动巡检和修复。

KubeSphere 部署环境的要求如下：

| 节点类型    | 节点数量 | 资源要求                           |
| :---------- | :------- | :--------------------------------- |
| master      | 1        | CPU：4 核， 内存：8GB， 硬盘：80GB |
| worker 节点 | 5        | CPU：4 核， 内存：8GB， 硬盘：80GB |

>  **注意**
>
> 如果集群将用于生产或者准生产的话，建议将 worker 节点的内存和硬盘至少提高 1 倍，中间件部分推荐使用云厂商提供的 PaaS 或者服务。

##### OpenFunction

手动安装OpenFunction，详细步骤请参照[官方文档](https://openfunction.dev/docs/getting-started/installation/)

- 使用helm 安装OpenFunction

```
kubectl create namespace openfunction
helm repo add openfunction https://openfunction.github.io/charts/
helm update
helm install openfunction openfunction/openfunction --version 0.1.0 -n openfunction
```

#### 第 2 步：安装MetalLB (可选)

推荐使用固态IP，它可以使您更容易的访问到全象云低代码平台。在使用MetalLB之前，需要准备和您的环境在同一环境下的一些可用的IP地址，并且可以被您访问到。详细信息可以参考 [官方文档](https://metallb.universe.tf/installation/) 。

- 下面步骤摘录自MetalLB的官方安装文档。

如果IPVS运行在kube-proxy模式下，且Kubernetes的版本为v1.14.2，你需要启用 strict ARP模式。如果使用的是kube-router的话，默认ARP为开启状态。

启用IPVS使用操作：

```
kubectl edit configmap -n kube-system kube-proxy
```

修改一些内容

```
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true
```

- 使用helm安装MetalLB

```
helm repo add metallb https://metallb.github.io/metallb
helm repo update
helm install metallb metallb/metallb -n metallb-system --create-namespace
```

- 为Kubernetes添加IP地址，比如文件名为 ip-pool.yaml

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

> 注意：
>
>  这些IP必须可用，并且能被您访问到。

- 使用kubectl使IP池生效。

```
kubectl apply -f ip-pool.yaml
```

#### 第 3 步：安装全象云低代码平台

**V2.0.0（不包含）之后的将使用helm charts安装**

- 下载相应安装版本

 您可以从我们的[官方发行版地址下载](https://github.com/quanxiang-cloud/quanxiang/releases/tag/v1.1.0) 也可以直接git clone对应的tag

```
git clone https://github.com/quanxiang-cloud/quanxiang.git
```

- 安装全象云低代码平台

全象云低代码平台可以支持生产环境和试用环境：

> - 生产环境：我们推荐您在安装全象前安装好数据库，缓存等中间件，参考配置选项内容。
> - 试用环境：安装工具会安装所有组件。

##### 配置项简介

生产环境，您需要将对应的中间件启用选项禁用，我们的配置文件在`quanxiang/values.yaml`, 下面是配置文件的一部分。

```
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

##### 安装

使用helm安装全象

```
cd quanxiang/deployment/charts
helm install lowcode -n lowcode ./quanxiang --create-namespace --timeout 1800s
```

##### 卸载

```
helm uninstall lowcode -n lowcode
```
</details>
  
#### 访问环境

##### 配置网关

如果未使用MetalLB或者OpenELB的话，可以参考 KubeSphere 的[官方文档](https://kubesphere.io/zh/docs/project-administration/project-gateway/)配置网关。我们推荐使用 LoadBalancer 方式配置网关。

##### 配置访问

访问 QuanxiangCloud 控制台，需要使用域名进行访问，可以配置 dns 或者指定本地 hosts 的方式进行访问。默认的用户名和密码是`admin@quanxiang.dev/654321a..`

- 通过 http://portal.qxp.com 访问 QuanxiangCloud 的管理端控制台。
- 通过 http://home.qxp.com 访问 QuanxiangCloud 的用户端。

> **注意**
>
> 如果需要修改访问域名，可参见 kubesphere 的[官方文档](https://kubesphere.io/zh/docs/project-user-guide/application-workloads/routes/)。

##### 初始化Web配置

**如果出现部分菜单栏没有出现的情况，请使用此节内容进行初始化前端界面**

Portal 控制台需要在安装完成后进行初始化，参照以下步骤进行初始化:

>
> 1. 在浏览器中打开全象云的管理端控制台
> 2. 在浏览器中打开开发者工具. MacOS快捷键 "Option + command + I", Windows/Linux快捷键"F12" 或者 "Control + Alt + I"
> 3. 在“开发者工具”中找到“source”，然后找到“snippets”.
> 4. 点击 "New snippet"然后在输入框中填入脚本内容，需要一个个的执行。
>  **注意: 脚本文件在 GITROOTDIR/deployment/scripts/ 中**

下图是执行脚本的位置：
![snippets](./doc/images/initialize_configuration.png)





## 快速开始

请参考官方文档[快速入门](https://docs.clouden.io/quickstart/app_modeling/)。

## 全象开源组件及功能列表

| 组件名称 | 组件功能 | 组件链接 |
| --- | --- | --- |
| app-center | 应用管理中心：应用基本信息及应用权限管理 |	https://github.com/quanxiang-cloud/appcenter |
| audit |	审计服务。	||
| dispatcher |	时间调度服务： 定时回掉指定任务接口 ||
| entrepot	| 任务管理中心：异步任务管理中心	| https://github.com/quanxiang-cloud/entrepot |
| fileserver |	文件服务：支持 aws s3 协议的对象存储上传与下载 |	https://github.com/quanxiang-cloud/fileserver |
| flow |	低代码流程引擎：低代码流程定义、低代码业务节点扩展和低代码其它业务整合 | https://github.com/quanxiang-cloud/flow |
| form |	表单引擎：表单高级组件、以及 schema 的处理，与 structor 配合使用	| https://github.com/quanxiang-cloud/form |
| goalie |	权限管理：角色权限管理，RBAC 权限模型	||
| kms| 	密钥管理：平台密钥管理及签名验证，外部密钥代理及鉴权	| https://github.com/quanxiang-cloud/kms |
| message |	消息服务：消息内容管理，邮件、站内信分发 | https://github.com/quanxiang-cloud/message |
| organizations |	组织服务：人员部门等信息管理，内置人员扩展字段服务功能	| https://github.com/quanxiang-cloud/organizations |
| persona |	应用配置中心：应用个性化配置数据存储	| https://github.com/quanxiang-cloud/persona |
|polyapi |	API 管理：API 注册，API 文档管理，第三方 API 代理，API 编排，API 统一调用	| https://github.com/quanxiang-cloud/polyapi |
| polygate	| API 网关：token/signature 认证，透明代理	| https://github.com/quanxiang-cloud/polygate |
| process |	流程引擎内核：流程模型定义、流程调度和实例数据记录	| https://github.com/quanxiang-cloud/process |
| qxp-web-home | web 用户端服务	| https://github.com/quanxiang-cloud/qxp-web |
| qxp-web-nginx	| web 静态文件，后面要废弃 ||
| qxp-web-portal |	web 管理端服务	||
| structor |	元数据管理：CURD 数据抽象，对接数据库管理	| https://github.com/quanxiang-cloud/structor |
| transaction |	已废弃	||
| warden |	认证服务：jwt 协议认证，生产管理 accesstoken，refreshtoken，支持第三方 jwt 协议 sso；||

除此之外，还有我们的博客版块，该部分内容全部是全象开发团队写作分享的一些技术干货，原计划在官网下一版本更新中增加，大家有兴趣可以点击 [Blog](https://github.com/quanxiang-cloud/website/tree/main/content/zh/blogs) 进行查看，也可以访问我们的公众号/[知乎号](https://www.zhihu.com/people/quan-xiang-yun-di-dai-ma/posts)（全象云低代码）查看历史内容。

## 交流互动

- 💬 公众号：全象云低代码
- 🤖 [Slack Channel](https://quanxiangcloud.slack.com/join/shared_invite/zt-17p7ne6h3-WtDNV72vnQ0vl8pdeLxABg)：如果希望认识更多开发者与使用者，可以加入 QuanXiang [Slack](https://quanxiangcloud.slack.com/join/shared_invite/zt-17p7ne6h3-WtDNV72vnQ0vl8pdeLxABg) 群。
- 🙌 [交流论坛](https://github.com/quanxiang-cloud/quanxiang/discussions)：如果在使用过程中遇到了问题，或发现了 bug，可以在 QuanXiang 的[讨论版块](https://github.com/quanxiang-cloud/quanxiang/discussions)中反馈。或者提 issue 也可。
