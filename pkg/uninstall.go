package pkg

import (
	"fmt"
	"io/ioutil"
	"k8s.io/client-go/util/homedir"
	"path/filepath"
	"errors"
)

func UninstallServece(namespace,depPath,kubeconfig string,uninstallMiddlerware bool) error {
	if kubeconfig == ""{
		if home := homedir.HomeDir(); home != "" {
			kubeconfig = filepath.Join(home, ".kube", "config")
		}else {
			fmt.Println("-------请输入 -k 参数获取kubeconfig信息")
			return errors.New("NO_KUBECONFIG")
		}
	}else {
		kubeconfig = kubeconfig
	}
	fmt.Println("----------------------------------------->开始卸载服务")
	releases,err := ioutil.ReadDir(depPath + "/quanxiang_charts")
	if err != nil {
		return err
	}
	for _,release := range releases{
		if release.IsDir(){
			fmt.Println("--------->卸载" + release.Name() + "服务 \n")
			command := "helm uninstall " + release.Name()  + " --kubeconfig " + kubeconfig + " -n "+ namespace
			err := execBash(command)
			if err != nil {
				return err
			}
			//fmt.Printf("--------->%s 卸载完成，如果出现Error错误请参照检查 \n", strings.Split(command," ")[2])
			//fmt.Println()
		}
	}
	if uninstallMiddlerware{
		fmt.Println("----------------------------------------->开始卸载中间件")
		releases,err = ioutil.ReadDir(depPath + "/middleware_deployment")
		if err != nil {
			return err
		}
		for _,release := range releases{
			if release.IsDir(){
				fmt.Println("--------->卸载" + release.Name() + "服务 \n")
				command := "helm uninstall " + release.Name()  + " --kubeconfig " + kubeconfig + " -n "+ namespace
				err := execBash(command)
				if err != nil {
					return err
				}
				//fmt.Printf("--------->%s 卸载完成，如果出现Error错误请参照检查 \n", strings.Split(command," ")[2])
				//fmt.Println()
			}
		}
	}

	return nil
}
