# Quanxiang platform installation
quanxiang project is a holographic platform installation tool written in go language, which can run on various architecture machines
## Prerequisites for using this installer

* helm3 needs to be installed on the deployment machine
* kubectl needs to be installed on the deployment machine
* go needs to be installed on the deployment machine
## Feature

* Support the optional deployment of middleware services (if you already have ready-made middleware available, you can set the middleware to false in the configuration file configs / configs.yml)
* Support the compilation and use of various architecture machines

## Installation steps
 >（1）Generate executable：
```shell
    git clone git@github.com:quanxiang-cloud/quanxiang.git
    git checkout master
    cd quanxiang
    CGO_ENABLED=0 GOOS=darwin/linux/windows/freebsd GOARCH=amd64/arm/386 go build -o quanxiangApp main.go
````
 >（2）Modify profile

`vi configs/configs.yml`
Set the middleware password and configure the service configuration information. Refer to the notes in the configuration file for details
 >（3）Deploy：

`./installAppMac start -k  -c -d  -i -H -P -u -p -n`

Parameter description：

| parameter | purpose |Description  |
------------|---------|--------------
| -c/--configfile | relative or absolute path of the configuration file  |Indicates the absolute or relative path of the current project configs / configs.yml |
| -d/--deploymentFile | absolute or relative path of deployment folder | absolute or relative path to the current project deployment folder  |
| -k/--kubeconfig |the profile path than can access to k8s cluster  | If the file is in the default location ~ /. Kube / config, you can not specify this parameter |
| -i/--middlerwareInit | middleware initialization | If specified, perform middleware initialization |
| -n/--namespace | The namespace in which the service is deployed in the k8s cluster | If not specified, the default namespace is default |

 > (4)Undeploy

`./installAppMac uninstall -n specify the namespace of the k8s cluster`
| parameter | purpose |Description  |
-------|------|----------
| -d/--deploymentFile | The path to the deployment folder  | Absolute or relative path to the current project deployment folder  |
| -k/--kubeconfig | the profile path than can access to k8s cluster  | If the file is in the default location ~ /. Kube / config, you can not specify this parameter |
| -n/--namespace | The namespace in which the service is deployed in the k8s cluster | If not specified, the default namespace is default |
| -u/--uninstallMiddlerware | Do you need to uninstall the middleware deployed by the tool | If there is no middleware deployed using this tool, you can not add this parameter. When the middleware is loaded and unloaded, it will be reported that there is no such resource and can be ignored |

 > (5)Configure gateway

Log in to kubesphere web console as project admin user, enter your project, enter the advanced settings page under project settings from the left navigation bar, and then click Set gateway

, select loadbalancer. Before selecting loadbalancer, you must configure the load balancer. The IP address of the load balancer will be bound to the gateway so that internal services and routes can be used

To access, you can use [porterlb](https://github.com/kubesphere/openelb) As load balancer
