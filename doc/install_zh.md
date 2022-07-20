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
将上述值写入数据库gits（host,ssh, known_hosts）dockers(host,user_name,secret,name)
INSERT INTO gits (id, host, token, name, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, tenant_id, known_hosts, ssh) VALUES 
              ('J2P57lAN', 'qxcr.xyz/', '', 'rsa', 1654857150396, 1654857150396, 0, '', '', '', '', 'WzE5Mi4xNjguMjA4LjNdOjEwMDIyIHNzaC1lZDI1NTE5IEFBQUFDM056YUMxbFpESTFOVEU1QUFBQUlPU0x3eHV6bXNuQ2RmcENoNGFuaUZCVDF2U040UUtUcUFZYlhVdHJHN0k4ClsxOTIuMTY4LjIwOC4zXToxMDAyMiBzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUJBUURFdXVZSW5aQW5wNUJGalV2MWdTVGp4RDJud2J2c2xVSUZGa2Z2TXRNRUs1cVROc0RUUGpWejlVSmZDSldnd2pjcUpkRXZWYVZNZlpMN3dWUlpUMnJreTJDUlJPNnFWdGFPeWpET3pXSzBhb1duc241L2VFdlVFM05SbGpqWk9IK2NQZEhzYkluU0llb1FFU0lBM0pEVllzMklDMndZRzQrMlVyQ3dzT0hwSFllcHVlcys2anhRdEpPa2lCb3krczlEWDFGZzRlREQ0dVFJMmg3azdFYVVydUZBcEJ2bW5TRktzaXhvMThTalcxMm5oSitIbVdXclg4OE5DRkVzKzJsaTRWSEpFb2Jwa1p6Y09NbGVUQVdwVTdQUHE0RFhOc0xpTGRIOEwrWi9COXRYZjYrSVByd0lXakhZaFlLbWhsNXZ0RXVHMU1zOU0rd1FSak1LaEJ0YgpbMTkyLjE2OC4yMDguM106MTAwMjIgZWNkc2Etc2hhMi1uaXN0cDI1NiBBQUFBRTJWalpITmhMWE5vWVRJdGJtbHpkSEF5TlRZQUFBQUlibWx6ZEhBeU5UWUFBQUJCQks3eHVSY0xlN25CcGVaVHNCeStWKzdnU2Z0VHFGM1d6dFRheUFzYXdoekFEU3ZpZXNtNjlmTklwTzZBSHB0TEZ1ZXhUa3U2WnJPWWlZVnB2a1RCTHVJPQo=', 'LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUJsd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFZRUF0VTFjZGJnU1liaTVtZ0FVR25KcW1lK2YrQ2lRWlk4UlUzYkRwNS83TVFSOUNRdG04TGFtCmNwSUpJaU5mUVhwZFYycG9aQnJXaGdQVVRRWlM5YzlJZk5iUE5aZmdFc3Mrd0trR2lPS2N3anNxS21ENVU2L1JUaW1GNTIKTWtDaHNidnluc0lET29URUpwdC85aWJ4REdjTEVNaUp3T1RoY3Uwd3JBWTNKdFl2NTE0ZlE2L1BBamFSNzNaS09YZFd0WQpNRy8rME5mc3FNZTlEMVVzRjBWUjMxLzhZakdmenpmZVdyWW8zNjk0SFNoU2p6T3R2YWllVE5CU1ZEWGhJdXdyZUE2QlhuCmxRRXBNZ05xNCtaYkFQTzlndG95K3ZabjBjRHVSM21oUFNxdXZqOWtrd3Uwb2tKRFhZbXBTaklhTG5iZDd2RjFQNFVPTUIKckh5dktDbWY1bGM0bkVacFBuRER0ek5RRkZOdWZPWFdyR0pkMFp5VWZ5VnZCYUgybFFDVHVOOEhmYWw2VGREd2lUT3pXbwpsQ1U4MEZQYlpJeUFLaEFNRzlwYjVJK3NCblgxZEVXdlBjMnZobFBLSWlnWnNlSXBVK0VzMi9sRlpaRFF5eFpFTFdKaEZFCkM2bmtqanoyNnhWbjZrZVBrZUhTREFjQTc0VXJ4b3grbWN2N1BGZmJBQUFGa0YxSUg4cGRTQi9LQUFBQUIzTnphQzF5YzIKRUFBQUdCQUxWTlhIVzRFbUc0dVpvQUZCcHlhcG52bi9nb2tHV1BFVk4ydzZlZit6RUVmUWtMWnZDMnBuS1NDU0lqWDBGNgpYVmRxYUdRYTFvWUQxRTBHVXZYUFNIeld6eldYNEJMTFBzQ3BCb2ppbk1JN0tpcGcrVk92MFU0cGhlZGpKQW9iRzc4cDdDCkF6cUV4Q2FiZi9ZbThReG5DeERJaWNEazRYTHRNS3dHTnliV0wrZGVIME92endJMmtlOTJTamwzVnJXREJ2L3REWDdLakgKdlE5VkxCZEZVZDlmL0dJeG44ODMzbHEyS04rdmVCMG9Vbzh6cmIyb25relFVbFExNFNMc0szZ09nVjU1VUJLVElEYXVQbQpXd0R6dllMYU12cjJaOUhBN2tkNW9UMHFycjQvWkpNTHRLSkNRMTJKcVVveUdpNTIzZTd4ZFQrRkRqQWF4OHJ5Z3BuK1pYCk9KeEdhVDV3dzdjelVCUlRibnpsMXF4aVhkR2NsSDhsYndXaDlwVUFrN2pmQjMycGVrM1E4SWt6czFxSlFsUE5CVDIyU00KZ0NvUURCdmFXK1NQckFaMTlYUkZyejNOcjRaVHlpSW9HYkhpS1ZQaExOdjVSV1dRME1zV1JDMWlZUlJBdXA1STQ4OXVzVgpaK3BIajVIaDBnd0hBTytGSzhhTWZwbkwrenhYMndBQUFBTUJBQUVBQUFHQUN3S2p0dEp5NjFSWWtTMm9DdU1mN2pGTE9iCnJjNmc0Q00xdG5EbXI4eWtGSGhxRVdvMCswVkFqaVhSeGcwSTBwMWdFMFRjQURmeWdFWUprZHVLZlo4eHJvZ295eW92R00KNGc1aHd6WmY1cnZKRjhIRDRuMHU3TnhBc1lpbnk2VlJ6ZzR4dE5MdVNaTk84RW1tSkxDVUhJdmtBdmZYTm83WjNSOHVCOQp3UElJL3JnTWxnTzdRcHNseWJFWldOd1NlL3QxRlYzRUVBc2s5Ty8vdGdMaG1ibTBFdEJwbVU1dlN4b0RpbnlzM1JNWlFkClQyMElCQmlWWkh6U1F5THloVGhxWVNzMERkSG54Nkx1OHVpOXNzd2Y2VjhwTjd1VDZiRGJvS3hOekpyZFFYZUJ3SEY2TDAKb2gxSG9YU0pycmNCbTk1Q2FkSGQwNXFWZUUrOXQ4UWxjN3ZTcmtxOVREUHhDL2JTRWFRQy9EZXo5RnEvVjM0WUh5VzRiUwpvSjFqU0lYT3lJTmVCYjZvVVB5VktGWFlUVVFndjk3ZUptVGhMTVkwVVNRWTVtUEc2UitMcTVtdSsvaXdBWUpraDdobVZxCjZmUDR2SXJFVGRvVWhWWHpzcHBLN3oxR2JMeGx1TDVjbHZSd0R2bjIyZ2dpV0JaUXJDdWJTa0QrU3d3MDBpVUhZQkFBQUEKd0VEM1IzMzBQUVZFQ0FjVkpsK2VTalBDWExUTHlzYlVOcGN2S3NWL0RQamtVczg0Mm0zOC8yWXNHaURDamIybVJJdEFjWQptQXZEa2xoeW4zRGYxalJreUlHVG5QNWNpVHFDbjlONDNFcXMralNlTVhkU3JYOUxLRTZmZzBsTFBISlMrYzdzM3ptNlU0Cmg0MzUwNEdyMytNeWs1aFcyVjltTDJaZUkzdHk0S3kweVFwdkxpVkF6N2V5QUZvbmM0N1REblJIS2xYMi9pc3lacXRSblIKQVVrVENxRUhjVnFVNmppa0xpVGVhdUlOQWZ0SSt0RGNHYURlaGdGZ1dMcXJVV2p3QUFBTUVBNWVpQ000Y2lvbkl4Z1oxNApUM0doWWpQQjR4R205WmsxalM0NWt5SXpHUWtNb3ExTjVlTGdGS0tzbEZIVzJ1V3RJOElURVg5Ym5NTTFIamxNYitYcjVhCjZzUyttRGZSTnVpNTFyc3hzcWY5em1CNFljZmtyYXRtbEU2QVdiMklGNEZOcU1BUUkrT0pFZm1Tb2c5Umdhc2dXcjY0dWgKT2tXMnpGamZNTTAzT21BL1pwbC9QTE43aEFpUCt3d2xQeXhSQzNySnk3SXJOODk1TDlUWDVJZ0d5eVFkeVBuakdOM1kzdAo4SXFldzVIZUhlSm1xQVQwendjVCs4N1hGa0VXZ2JBQUFBd1FESjRMVkN2Mk9nVXUvZ0RXUFZTbGpwNlRVRkJOZDVscUV5CnVyYmtycHZ5VWNnbVlFaXJjZi80S3JxbEgwb25CRjR3R0NXVGNkZzZtK3MyZjVWSnFmZ29YbFRTZFNSSmVEQUFFZkdzL1YKNUxsbU54ZFZuVlkzeTJaRXFSNXpzNWQ3RDVqam1NMFkzc1NHME5MTWQwVmtSeXVFdmNaRkI4Qm0yNFh2WDNtWUlnc3pWbgp6VXhZS1h1eTVCKzd2TFVGWk9ac0VmTWQxOHFDdkhvQnQrd0lrVnFXdElqNytqZG5JcFlzR2lpdTZObHRMa3MxMyswcnRhCnlCUDFYZTZ0TURTMEVBQUFBV2VtaGxibXhwYm1ScGJtZEFlWFZ1YVdaNUxtTnZiUUVDQXdRRgotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0K');

INSERT INTO dockers (id, host, user_name, name_space, secret, name, created_at, updated_at, deleted_at, created_by, updated_by, deleted_by, tenant_id) VALUES ('1', 'qxcr.xyz/', 'qxptest', 'privitetest/', 'ZHU**jie9', 'qxcr', null, null, null, null, null, null, null);
（8）./installAll_linux start -n lowcode 
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