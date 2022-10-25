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
	"errors"
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strings"

	"k8s.io/client-go/util/homedir"
)

func UninstallServece(namespace, depPath, kubeconfig string, uninstallMiddlerware bool, skipDapr bool) error {
	if kubeconfig == "" {
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		} else {
			fmt.Println("-------请输入 -k 参数获取kubeconfig信息")
			return errors.New("NO_KUBECONFIG")
		}
	}
	fmt.Println("----------------------------------------->开始卸载服务")
	releases, err := ioutil.ReadDir(depPath + "/quanxiang_charts")
	if err != nil {
		return err
	}
	for _, release := range releases {
		if release.IsDir() {
			fmt.Println("--------->卸载" + release.Name() + "服务 \n")
			var command string
			switch {
			case strings.Contains(release.Name(), "builder"):
				command = fmt.Sprintf("helm uninstall %s --kubeconfig %s -n builder", release.Name(), kubeconfig)
			case strings.Contains(release.Name(), "serving"):
				command = fmt.Sprintf("helm uninstall %s --kubeconfig %s -n serving", release.Name(), kubeconfig)
			case strings.Contains(release.Name(), "fluent"):
				command = fmt.Sprintf("helm uninstall %s  --kubeconfig %s -n builder ", release.Name(), kubeconfig)
			default:
				command = "helm uninstall " + release.Name() + " --kubeconfig " + kubeconfig + " -n " + namespace
			}
			err := execBash(command)
			if err != nil {
				return err
			}
			//fmt.Printf("--------->%s 卸载完成，如果出现Error错误请参照检查 \n", strings.Split(command," ")[2])
			//fmt.Println()
		}
	}
	if uninstallMiddlerware {
		fmt.Println("----------------------------------------->开始卸载中间件")
		releases, err = ioutil.ReadDir(depPath + "/middleware_deployment")
		if err != nil {
			return err
		}
		for _, release := range releases {
			if release.IsDir() {
				fmt.Println("--------->卸载" + release.Name() + "服务 \n")
				var command string
				switch {
				case strings.Contains(release.Name(), "dapr"):
					command = "helm uninstall " + release.Name() + " --kubeconfig " + kubeconfig + " -n dapr-system"
					/*
						case strings.Contains(release.Name(), "builder"):
							command = "helm uninstall " + release.Name() + " --kubeconfig " + kubeconfig + " -n builder"
						case strings.Contains(release.Name(), "serving"):
							command = "helm uninstall " + release.Name() + " --kubeconfig " + kubeconfig + " -n serving"
						case strings.Contains(release.Name(), "fluent"):
							command = "helm uninstall " + release.Name() + " --kubeconfig " + kubeconfig + " -n builder"
					*/
				default:
					command = "helm uninstall " + release.Name() + " --kubeconfig " + kubeconfig + " -n " + namespace
				}
				if skipDapr && strings.Contains(release.Name(), "dapr") {
					fmt.Println("跳过Dapr系统的卸载")
				} else {
					err := execBash(command)
					if err != nil {
						return err
					}
				}

			}
		}
	}
	command := "kubectl delete secret rsa -n builder --kubeconfig " + kubeconfig
	err = execBash(command)
	if err != nil {
		fmt.Println(err)
	}
	command = "kubectl delete secret faas-docker -n serving --kubeconfig " + kubeconfig
	err = execBash(command)
	if err != nil {
		fmt.Println(err)
	}
	command = "kubectl delete secret faas-docker -n builder" + " --kubeconfig " + kubeconfig
	err = execBash(command)
	if err != nil {
		fmt.Println(err)
	}
	return nil
}
