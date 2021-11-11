# 全象平台安装
quanxiang项目是go语言编写的可以运行于各种架构机器上的全象平台安装工具
## 使用该安装器部署的前提条件

* 部署机器上需要安装helm3
* 部署机器上需要安装kubectl
* 部署机器上需要安装go环境
## 特点

* 支持中间件服务的可选择部署，（如果你已经有现成的中间件可用可以在配置文件configs/configs.yml中将该中间件置为false）
* 支持各个架构机器的编译部署

## 安装步骤
 > （1）生成可执行文件：
```shell
    git clone git@github.com:quanxiang-cloud/quanxiang.git
    git checkout master
    cd quanxiang
    CGO_ENABLED=0 GOOS=darwin/linux/windows/freebsd GOARCH=amd64/arm/386 go build -o quanxiangApp main.go
````
 > （2）修改配置文件

`vi configs/configs.yml`
设置中间件密码和配置服务配置信息，具体可参考配置文件中注释

 > （3）安装：

`./installAppMac start -k  -c  -d -i -H -P -u -p -n `
| 参数 | 作用 |使用说明  |
-------|------|----------
| -c/--configfile | 配置文件路径 |当前项目configs/configs.yml的绝对或者相对路径  |
| -d/--deploymentFile |部署文件夹的路径  |当前项目deployment文件夹的绝对或相对路径  |
| -k/--kubeconfig |访问k8s集群的配置文件路径  | 如果该文件在默认位置～/.kube/config可以不指定该参数 |
| -i/--middlerwareInit | 中间件是否需要初始化 | 如果指定则对中间件进行初始化 |
| -n/--namespace | 服务部署于k8s集群的命名空间 | 如果不指定默认为default |


 > (4)卸载服务

`./installAppMac uninstall -n k8s的namespace`
| 参数 | 作用 |使用说明  |
-------|------|----------
| -d/--deploymentFile |部署文件夹的路径  |当前项目deployment文件夹的绝对或相对路径  |
| -k/--kubeconfig |访问k8s集群的配置文件路径  | 如果该文件在默认位置～/.kube/config可以不指定该参数 |
| -n/--namespace | 卸载的服务部署于k8s集群的命名空间 | 如果不指定默认为default |
| -u/--uninstallMiddlerware | 是否需要卸载该工具部署的中间件 | 如果没有使用该工具部署的中间件可以不加该参数，加了卸载的时候会报没有此资源忽略即可 |

> (5)配置网关

以 project-admin 用户登录 KubeSphere Web 控制台，进入您的项目，从左侧导航栏进入项目设置下的高级设置页面，然后点击设置网关
，选择LoadBalancer，在选择 LoadBalancer 前，您必须先配置负载均衡器。负载均衡器的 IP 地址将与网关绑定以便内部的服务和路由可以访问，您可以使用 [PorterLB](https://github.com/kubesphere/openelb) 作为负载均衡器
