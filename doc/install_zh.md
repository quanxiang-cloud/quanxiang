# 前提条件

- 已安装好 Kubernetes  环境 (<= v1.21.*)。
- 已安装好 OpenFunction 环境 (v0.5.0 及以上)。

## 第 1 步：安装 KubeSphere和OpenFuction

### KubeSPhere

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

### OpenFunction

手动安装OpenFunction，详细步骤请参照[官方文档](https://openfunction.dev/docs/getting-started/installation/)

- 使用helm 安装OpenFunction

```
kubectl create namespace openfunction
helm repo add openfunction https://openfunction.github.io/charts/
helm update
helm install openfunction openfunction/openfunction --version 0.1.0 -n openfunction
```

## 第 2 步：安装MetalLB (可选)

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

## 第 3 步：安装全象云低代码平台

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

### 配置项简介

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

### 安装

使用helm安装全象

```
cd quanxiang/deployment/charts
helm install lowcode -n lowcode ./quanxiang --create-namespace --timeout 1800s
```

### 卸载

```
helm uninstall lowcode -n lowcode
```

  
## 访问环境

### 配置网关

如果未使用MetalLB或者OpenELB的话，可以参考 KubeSphere 的[官方文档](https://kubesphere.io/zh/docs/project-administration/project-gateway/)配置网关。我们推荐使用 LoadBalancer 方式配置网关。

### 配置访问

访问 QuanxiangCloud 控制台，需要使用域名进行访问，可以配置 dns 或者指定本地 hosts 的方式进行访问。默认的用户名和密码是`admin@quanxiang.dev/654321a..`

- 通过 http://portal.qxp.com 访问 QuanxiangCloud 的管理端控制台。
- 通过 http://home.qxp.com 访问 QuanxiangCloud 的用户端。

> **注意**
>
> 如果需要修改访问域名，可参见 kubesphere 的[官方文档](https://kubesphere.io/zh/docs/project-user-guide/application-workloads/routes/)。

### 初始化Web配置

**如果出现部分菜单栏没有出现的情况，请使用此节内容进行初始化前端界面**

Portal 控制台需要在安装完成后进行初始化，参照以下步骤进行初始化:

>
> 1. 在浏览器中打开全象云的管理端控制台
> 2. 在浏览器中打开开发者工具. MacOS快捷键 "Option + command + I", Windows/Linux快捷键"F12" 或者 "Control + Alt + I"
> 3. 在“开发者工具”中找到“source”，然后找到“snippets”.
> 4. 点击 "New snippet"然后在输入框中填入脚本内容，需要一个个的执行。
>  **注意: 脚本文件在 GITROOTDIR/deployment/scripts/ 中**

下图是执行脚本的位置：
![snippets](./images/initialize_configuration.png)

