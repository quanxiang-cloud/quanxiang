全象云低代码平台提供了一套快速安装程序，使用者只需一条指令即可安装全象云低代码平台，目前提供两类安装方式：

- [在 kubesphere 环境中安装](#在Kubesphere环境中安装（推荐使用）)
- [原生 Kubernetes 环境上安装](#原生Kubernetes环境上安装)



## 前提条件

已安装好 Kubernetes  环境。



## 在 Kubesphere 环境中安装（推荐使用）

### 第 1 步：安装 KubeSphere

安装 KubeSphere 有两种方式：

- 直接安装 KubeSphere，详细步骤参见 [官方文档](https://kubesphere.io/docs/)。
- 安装  [KubeSphere(R)（QKE） ](https://docsv3.qingcloud.com/container/qke/)（**推荐**），可以一键部署高可用的 KubeSphere 集群，并支持集群自动巡检和修复。

KubeSphere 部署环境的要求如下：

| 节点类型    | 节点数量 | 资源要求                           |
| :---------- | :------- | :--------------------------------- |
| master      | 1        | CPU：4 核， 内存：8GB， 硬盘：80GB |
| worker 节点 | 5        | CPU：4 核， 内存：8GB， 硬盘：80GB |

> **注意**
>
> 如果集群将用于生产或者准生产的话，建议将 worker 节点的内存和硬盘至少提高 1 倍，中间件部分推荐使用云厂商提供的 PaaS 或者服务。



### 第 2 步：安装全象云低代码平台

安装全象云低代码平台前，您首先需要确保满足以下条件，然后再从我们的 release 中可以选择您需要的版本。

- 运行安装程序的系统可以访问 KubeSphere 集群。
- 已正确安装 kubectl，如果没有请先 [安装 kubectl](!https://kubernetes.io/docs/tasks/tools/)。
- 已正确配置 kubeconfig，若没配置请先完成配置。
  - QKE  kubeconfig 可通过 QingCloud 控制台获取；
  - KubeSphere  kubeconfig 请参见 [官方文档](!https://kubesphere.com.cn/docs/) 或者 [求助社区](!https://github.com/kubesphere) 完成配置。
- 已安装 helm3，安装过程请参见 [官方文档](!https://helm.sh/docs/intro/install/)。



#### 使用发行版

如果不希望自己编译的话可以直接使用我们发行版，点击 [下载地址](!https://github.com/quanxiang-cloud/quanxiang/releases)。***注意区别不同版本的系统架构***。



#### 使用源码编译 

需要先 git clone 项目源代码进行编译。需要注意的是修改指令中的 GOOS 和 GOARCH 以匹配系统架构，以 Linux amd64 为例：

```bash
 git clone https://github.com/quanxiang-cloud/quanxiang.git
 cd quanxiang
 git checkout master
 CGO_ENABLED=0 GOOS=linux GOARCH=adm64 go build -o installApp main.go
```

> **说明**
>
> - GOOS 可用系统：darwin、Linux、windows、freebsd 等;
> - GOARCH 可用架构：amd64、386、arm 等。



#### 开始安装

全象云低代码平台支持生产部署和试用部署：

- 生产环境可以先部署好中间件，具体内容可以参考 [修改配置文件](#修改配置文件)。
- 试用部署可以选择全部容器部署。



##### 修改配置文件

如果您已经部署好中间件服务，并打算将其用于全象低代码平台安装，可以在配置文件  `configs/configs.yml`  中将对应的中间件中 `enabled: true` 改为 `false`。**具体配置请参照下文内注释**。

```bash shell
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



##### 安装

通过执行 `installApp` 指令来安装全象云低代码平台，试用版执行如下指令安装：

```bash shell
./installApp start -k ~/.kube/config -i -n lowcode
```

参数说明：

| 参数                 | 作用                          | 使用说明                                                |
| -------------------- | ----------------------------- | ------------------------------------------------------- |
| -c/--configfile      | 配置文件路径                  | 当前项目 configs/configs.yml 的绝对或者相对路径。       |
| -d/--deploymentFile  | 部署文件夹的路径              | 当前项目 deployment 文件夹的绝对或相对路径。            |
| -k/--kubeconfig      | 访问 k8s 集群的配置文件路径   | 如果该文件在默认位置 ～/.kube/config 可以不指定该参数。 |
| -i/--middlerwareInit | 中间件是否需要初始化          | 如果指定则对中间件进行初始化。                          |
| -n/--namespace       | 服务部署于 k8s 集群的命名空间 | 如果不指定默认为 default。                              |

##### 卸载

通过执行 `installApp` 指令进行卸载操作：

```bash shell
./installApp uninstall -n lowcode
```

参数的详细解释如下：

| 参数                      | 作用                                | 使用说明                                                     |
| ------------------------- | ----------------------------------- | ------------------------------------------------------------ |
| -d/--deploymentFile       | 部署文件夹的路径                    | 当前项目 deployment 文件夹的绝对或相对路径。                 |
| -k/--kubeconfig           | 访问 k8s 集群的配置文件路径         | 如果该文件在默认位置 ～/.kube/config 可以不指定该参数。      |
| -n/--namespace            | 卸载的服务部署于 k8s 集群的命名空间 | 如果不指定默认为 default。                                   |
| -u/--uninstallMiddlerware | 是否需要卸载工具部署的中间件        | 若没有使用工具部署的中间件可以不引用此参数。若使用，卸载时报错没有此资源，忽略即可。 |

#### 访问环境

##### 配置网关

参考Kubesphere的[官方文档](https://kubesphere.io/zh/docs/project-administration/project-gateway/)。我们推荐使用LoadBalancer方式配置网关

##### 配置访问

访问的QuanxiangCloud控制台，需要使用域名进行访问，可以配置dns或者指定本地hosts的方式进行访问。默认的用户名和密码是`Admin@Admin.com/654321a..`

- 通过http://portal.qxp.com访问QuanxiangCloud的管理端控制台。
- 通过http://home.qxp.com访问QuanxiangCloud的用户端观礼台。

> **注意**
>
> 如果需要修改访问域名，请参考kubesphere的[官方文档](https://kubesphere.io/zh/docs/project-user-guide/application-workloads/routes/)

## 原生 Kubernetes 环境上安装

## 前提条件

已安装好 Kubernetes  环境。

### 第 1 步：安装全象云低代码平台

安装全象云低代码平台前，您首先需要确保满足以下条件，然后再从我们的 release 中可以选择您需要的版本。

- 已正确安装 kubectl，如果没有请先 [安装 kubectl](!https://kubernetes.io/docs/tasks/tools/)。
- 已正确配置 kubeconfig，若没配置请先完成配置。
- 已安装 helm3，安装过程请参见 [官方文档](!https://helm.sh/docs/intro/install/)。

#### 使用发行版

如果不希望自己编译的话可以直接使用我们发行版，点击 [下载地址](!https://github.com/quanxiang-cloud/quanxiang/releases)。***注意区别不同版本的系统架构***。



#### 使用源码编译 

需要先 git clone 项目源代码进行编译。需要注意的是修改指令中的 GOOS 和 GOARCH 以匹配系统架构，以 Linux amd64 为例：

```bash
 git clone https://github.com/quanxiang-cloud/quanxiang.git
 cd quanxiang
 git checkout master
 CGO_ENABLED=0 GOOS=linux GOARCH=adm64 go build -o installApp main.go
```

> **说明**
>
> - GOOS 可用系统：darwin、Linux、windows、freebsd 等;
> - GOARCH 可用架构：amd64、386、arm 等。



#### 开始安装

全象云低代码平台支持生产部署和试用部署：

- 生产环境可以先部署好中间件，具体内容可以参考 [修改配置文件](#修改配置文件)。
- 试用部署可以选择全部容器部署。



##### 修改配置文件

如果您已经部署好中间件服务，并打算将其用于全象低代码平台安装，可以在配置文件  `configs/configs.yml`  中将对应的中间件中 `enabled: true` 改为 `false`。**具体配置请参照下文内注释**。

```bash shell
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



##### 安装

通过执行 `installApp` 指令来安装全象云低代码平台，试用版执行如下指令安装：

```bash shell
./installApp start -k ~/.kube/config -i -n lowcode
```

参数说明：

| 参数                 | 作用                          | 使用说明                                                |
| -------------------- | ----------------------------- | ------------------------------------------------------- |
| -c/--configfile      | 配置文件路径                  | 当前项目 configs/configs.yml 的绝对或者相对路径。       |
| -d/--deploymentFile  | 部署文件夹的路径              | 当前项目 deployment 文件夹的绝对或相对路径。            |
| -k/--kubeconfig      | 访问 k8s 集群的配置文件路径   | 如果该文件在默认位置 ～/.kube/config 可以不指定该参数。 |
| -i/--middlerwareInit | 中间件是否需要初始化          | 如果指定则对中间件进行初始化。                          |
| -n/--namespace       | 服务部署于 k8s 集群的命名空间 | 如果不指定默认为 default。                              |
| -g/--ngGateWay       | 是否使用nginx controller作为访问入口 | 如果不指定默认不使用（需要自己设置网关进行访问）。                              |

##### 卸载

通过执行 `installApp` 指令进行卸载操作：

```bash shell
./installApp uninstall -n lowcode
```

参数的详细解释如下：

| 参数                      | 作用                                | 使用说明                                                     |
| ------------------------- | ----------------------------------- | ------------------------------------------------------------ |
| -d/--deploymentFile       | 部署文件夹的路径                    | 当前项目 deployment 文件夹的绝对或相对路径。                 |
| -k/--kubeconfig           | 访问 k8s 集群的配置文件路径         | 如果该文件在默认位置 ～/.kube/config 可以不指定该参数。      |
| -n/--namespace            | 卸载的服务部署于 k8s 集群的命名空间 | 如果不指定默认为 default。                                   |
| -u/--uninstallMiddlerware | 是否需要卸载工具部署的中间件        | 若没有使用工具部署的中间件可以不引用此参数。若使用，卸载时报错没有此资源，忽略即可。 |

#### 访问环境

##### 配置网关（如果安装时指定了-g参数则不需要配置网关）

推荐 参考porterlb的[官方文档](https://porterlb.io/docs/overview/)。我们推荐使用LoadBalancer方式配置网关

##### 配置访问

访问的QuanxiangCloud控制台，需要使用域名进行访问，可以配置dns或者指定本地hosts的方式进行访问。默认的用户名和密码是`Admin@Admin.com/654321a..`

#######没有单独设置网关（安装时使用了-g参数）
- 通过http://portal.qxp.com:32032访问QuanxiangCloud的管理端控制台。
- 通过http://home.qxp.com:32032访问QuanxiangCloud的用户端观礼台。
#######配置了网关访问
- 通过http://portal.qxp.com访问QuanxiangCloud的管理端控制台。
- 通过http://home.qxp.com访问QuanxiangCloud的用户端观礼台。

> **注意**
>
> 如果需要修改访问域名，请参考kubesphere的[官方文档](https://kubesphere.io/zh/docs/project-user-guide/application-workloads/routes/)