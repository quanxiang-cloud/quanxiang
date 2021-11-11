package pkg

import (
	"fmt"
	"io/ioutil"
	"strings"
)

func Start(kubeconfig,namespace,configFile,depFile string, mysqlInit bool)  {
	if namespace != "default"{
		command := "kubectl create ns "+ namespace + " --kubeconfig " + kubeconfig
		err := execBash(command)
		if err != nil {
			fmt.Println("创建命名空间错误，请检查")
		}
	}
	fmt.Println("--------------------------------------->开始部署中间件")
	fmt.Println()
	configs,err := ParaseConfig(configFile)
	if err != nil {
		return
	}
	needMiddleware,err := middlewareInstall(namespace,depFile,kubeconfig,configs)
	if err != nil {
		fmt.Println()
		fmt.Println(err)
		fmt.Println("--------------------------------------->中间件部署失败")
		return
	}
	fmt.Println()
	fmt.Println("----------------------------------------->中间件部署完成")
	fmt.Println("--------------------------------------->正在检查中间件是否运行，请等待。。。。。。")
	if needMiddleware{
		err = statusCheck(kubeconfig,namespace)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println()
	}else {
		fmt.Println("--------------------------------------->中间件安装成功")
	}

	if mysqlInit {
		fmt.Println("----------------------------------------->开始初始化mysql")
		releases,_ := ioutil.ReadDir(depFile + "/schemas")
		for _,release := range releases{
			err := deployMysql(kubeconfig,namespace,release.Name(),depFile,configs)
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
	releases,_ := ioutil.ReadDir(depFile + "/quanxiang_charts")
	for _,release := range releases{
		if release.IsDir() {
			fmt.Println("--------->部署" + release.Name() + "服务 \n")
			err := ModifyValuesFile(depFile+"/quanxiang_charts/"+release.Name()+"/values.yaml",configFile)
			if err != nil {
				fmt.Println("修改values.yaml失败")
				fmt.Println(err)
			}
			command := "helm install " + release.Name() + " " + depFile + "/quanxiang_charts/" + release.Name() + " --kubeconfig "+kubeconfig + " -n "+ namespace + " --timeout 1800s"
			execBash(command)
			fmt.Printf("--------->%s 部署完成，如果出现Error错误请参照检查 \n", strings.Split(command," ")[2])
			fmt.Println()
		}
	}
	fmt.Println("----------------------------------------->开始进行部署状态检查")
	err = statusCheck(kubeconfig,namespace)
	if err != nil {
		fmt.Println(err)
		return
	}
}

