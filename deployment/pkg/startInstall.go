/*
Copyright 2020 QuanxiangCloud Authors
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package pkg

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func Start(kubeconfig, namespace, configFile, depFile, registry, regisUser, regisPass string, mysqlInit, ngGateway, isOffline bool) {
	if namespace != "default" {
		command := "kubectl create ns " + namespace + " --kubeconfig " + kubeconfig
		err := execBash(command)
		if err != nil {
			fmt.Println("创建命名空间错误，请检查")
		}
		//command = "kubectl create secret docker-registry lowcode --docker-username=qxpkevin --docker-password=LzbXp9Er --docker-server=qxcr.io -n " + namespace
	}
	if isOffline {
		importImages(registry, depFile, regisUser, regisPass)
	}

	if ngGateway && !isOffline {
		command := "helm install nginx-ingress " + depFile + "/nginx-ingress-controller" + " --kubeconfig " + kubeconfig + " -n " + namespace + " --timeout 1800s"
		execBash(command)
		fmt.Printf("--------->%s 部署完成，如果出现Error错误请参照检查 \n", strings.Split(command, " ")[2])
		fmt.Println()
	}

	if ngGateway && isOffline {
		command := "helm install nginx-ingress " + depFile + "/nginx-ingress-controller" + " --kubeconfig " + kubeconfig + " -n " +
			namespace + " --timeout 1800s --create-namespace --set image.registry=" + registry + " --set image.repository=nginx-ingress-controller --set defaultBackend.image.registry=" +
			registry + " --set defaultBackend.image.repository=nginx"
		execBash(command)
		fmt.Printf("--------->%s 部署完成，如果出现Error错误请参照检查 \n", strings.Split(command, " ")[2])
		fmt.Println()
	}
	fmt.Println("--------------------------------------->开始部署中间件")
	fmt.Println()
	configs, err := ParaseConfig(configFile)
	if err != nil {
		fmt.Println(err)
		return
	}
	needMiddleware, err := middlewareInstall(namespace, depFile, kubeconfig, registry, configs, isOffline)
	if err != nil {
		fmt.Println()
		fmt.Println(err)
		fmt.Println("--------------------------------------->中间件部署失败")
		return
	}
	fmt.Println()
	fmt.Println("----------------------------------------->中间件部署完成")
	fmt.Println("--------------------------------------->正在检查中间件是否运行，请等待。。。。。。")
	if needMiddleware {
		err = statusCheck(kubeconfig, namespace)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println()
	} else {
		fmt.Println("--------------------------------------->中间件安装成功")
	}
	if mysqlInit {
		fmt.Println("----------------------------------------->开始初始化mysql")
		releases, _ := ioutil.ReadDir(depFile + "/schemas")
		for _, release := range releases {
			err := deployMysql(kubeconfig, namespace, release.Name(), depFile, configs)
			if err != nil {
				fmt.Println("---------------------------------------> 数据库初始化失败")
				return
			}
			fmt.Printf("--------->%s 部署完成，如果出现Error错误请参照检查 \n", release.Name())
		}
		fmt.Println("---------------------------------------> 数据库初始化完成")
	}
	fmt.Println()
	fmt.Println("----------------------------------------->开始部署服务")
	releases, _ := ioutil.ReadDir(depFile + "/quanxiang_charts")
	for _, release := range releases {
		if release.IsDir() {
			fmt.Println("--------->部署" + release.Name() + "服务 \n")
			if !strings.Contains(release.Name(), "fluent") && !strings.Contains(release.Name(), "builder") {
				err := ModifyValuesFile(depFile+"/quanxiang_charts/"+release.Name()+"/values.yaml", namespace, configs, ngGateway)
				if err != nil {
					fmt.Println("修改values.yaml失败")
					fmt.Println(err)
				}
			}
			var command string
			switch {
			case strings.Contains(release.Name(), "builder"):
				command = fmt.Sprintf("helm install %s %s/quanxiang_charts/%s --kubeconfig %s -n builder --set namespace=%s  --set lowcode=%s --timeout 1800s --create-namespace",
					release.Name(), depFile, release.Name(), kubeconfig, "builder", namespace)
			case strings.Contains(release.Name(), "serving"):
				command = fmt.Sprintf("helm install %s %s/quanxiang_charts/%s --kubeconfig %s -n serving --set namespace=%s --timeout 1800s --create-namespace",
					release.Name(), depFile, release.Name(), kubeconfig, "serving")
			case strings.Contains(release.Name(), "fluent"):
				command = fmt.Sprintf("helm install %s %s/quanxiang_charts/%s --kubeconfig %s -n builder --set namespace=%s --timeout 1800s --create-namespace",
					release.Name(), depFile, release.Name(), kubeconfig, "builder")
			default:
				command = fmt.Sprintf("helm install %s %s/quanxiang_charts/%s --kubeconfig %s -n %s --set namespace=%s --timeout 1800s --create-namespace",
					release.Name(), depFile, release.Name(), kubeconfig, namespace, namespace)
			}
			execBash(command)
			fmt.Printf("--------->%s 部署完成，如果出现Error错误请参照检查 \n", strings.Split(command, " ")[2])
			fmt.Println()
		}
	}
	fmt.Println("----------------------------------------->开始进行部署状态检查")
	err = statusCheck(kubeconfig, namespace)
	if err != nil {
		fmt.Println(err)
		return
	}
	err = applyGitSeret(configs.Faas.Git.GitSSh, configs.Faas.Git.KnownHosts, configs.Faas.Git.Privatekey, kubeconfig, namespace)
	if err != nil {
		fmt.Println(err)
		return
	}
	err = applyHarbor(configs.Faas.Docker.Name, configs.Faas.Docker.Pass, configs.Faas.Docker.Server)
	if err != nil {
		fmt.Println(err)
		return
	}
	command := "helm install searchindex " + depFile + "/search_index" + " --kubeconfig " + kubeconfig + " -n " + namespace + " --timeout 1800s"
	execBash(command)
	command = "helm install auth " + depFile + "/portalauth" + " --kubeconfig " + kubeconfig + " -n " + namespace + " --timeout 1800s"
	execBash(command)
	fmt.Println("----------------------------------------->部署完成")
}
