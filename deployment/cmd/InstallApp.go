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
package cmd

import (
	"fmt"
	"os"
	"quanxiang/pkg"

	"github.com/spf13/cobra"
)

var (
	kubeconfig     string
	namespace      string
	configfile     string
	deploymentFile string
	mysqlInit      bool
	ngGateWay      bool
	isOffline      bool
	registry       string
	registryUser   string
	registryPass   string
	skipDapr       bool
)
var uninstallMiddlerware bool

var rootCmd = &cobra.Command{
	Use:   "Install App",
	Short: "全象平台安装器",
	Long:  `根据参数安装部署全象平台`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("需要命令和参数")
		fmt.Println("可以使用 -h 参数查看具体操作")
	},
}

func Execute() {
	uninstallCmd := &cobra.Command{
		Use:   "uninstall",
		Short: "卸载服务",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("             ********************************************************************************")
			fmt.Println("             *                                                                              *")
			fmt.Println("             *                                  卸载程序开始运行                            *")
			fmt.Println("             *                                                                              *")
			fmt.Println("             ********************************************************************************")
			fmt.Println()
			err := pkg.UninstallServece(namespace, deploymentFile, kubeconfig, uninstallMiddlerware, skipDapr)
			if err != nil {
				fmt.Println(err)
				fmt.Println("         -------------卸载失败，请根据提示先检查-------------------")
			} else {
				fmt.Println("         -------------卸载成功，如部署请使用start命令-------------------")
			}
		},
	}
	startCmd := &cobra.Command{
		Use:   "start",
		Short: "启动安装",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("             ********************************************************************************")
			fmt.Println("             *                                                                              *")
			fmt.Println("             *                                  部署程序开始运行                            *")
			fmt.Println("             *                                                                              *")
			fmt.Println("             ********************************************************************************")
			fmt.Println()
			pkg.Start(kubeconfig, namespace, configfile, deploymentFile, registry, registryUser, registryPass, mysqlInit, ngGateWay, isOffline)
		},
	}
	//startCmd.Flags().BoolVarP(&daemon, "deamon", "d", false, "is daemon?")
	startCmd.Flags().StringVarP(&kubeconfig, "kubeconfig", "k", "~/.kube/config", "kubeconfig绝对路径,如果kubeconfig文件不在～/.kube/config个路径下需要指定")
	startCmd.Flags().StringVarP(&configfile, "configfile", "c", "./configs/configs.yml", "配置文件路径")
	startCmd.Flags().StringVarP(&deploymentFile, "deploymentFile", "d", "./deployment", "部署服务（deployment文件夹相对或绝对路径）文件夹路径")
	startCmd.Flags().BoolVarP(&mysqlInit, "middlerwareInit", "i", false, "是否需要初始化mysql，初次安装需要指定")
	startCmd.Flags().BoolVarP(&ngGateWay, "ngGateWay", "g", false, "是否需要部署nginx-controller配置ingress访问")
	startCmd.Flags().StringVarP(&namespace, "namespace", "n", "default", "容器部署在k8s的命名空间,默认为default")
	startCmd.Flags().BoolVarP(&isOffline, "isOffline", "o", false, "是否可联网环境，默认否")
	startCmd.Flags().StringVarP(&registry, "registry", "r", "qxcr.io/qxp", "如果是内网环境请设置自己的镜像仓库")
	startCmd.Flags().StringVarP(&registryUser, "registryUser", "U", "admin", "如果是内网环境请设置镜像仓库的用户名")
	startCmd.Flags().StringVarP(&registryPass, "registryPass", "P", "Harbor12345", "如果是内网环境请设置像仓库的密码")
	rootCmd.AddCommand(startCmd)
	uninstallCmd.Flags().StringVarP(&namespace, "namespace", "n", "default", "容器部署在k8s的命名空间,默认为default")
	uninstallCmd.Flags().BoolVarP(&uninstallMiddlerware, "uninstallMiddlerware", "u", false, "是否需要卸载中间件（只有中间件是该工具部署的才可以指定）")
	uninstallCmd.Flags().StringVarP(&deploymentFile, "deploymentFile", "d", "./deployment", "部署服务（deployment文件夹相对或绝对路径）文件夹路径")
	uninstallCmd.Flags().StringVarP(&kubeconfig, "kubeconfig", "k", "~/.kube/config", "kubeconfig绝对路径,如果kubeconfig文件不在～/.kube/config个路径下需要指定")
	uninstallCmd.Flags().BoolVarP(&skipDapr, "skipDapr", "s", false, "是否卸载dapr")
	rootCmd.AddCommand(uninstallCmd)

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
