package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"quanxiang/pkg"
)
var (
	kubeconfig string
	namespace string
	configfile string
	deploymentFile string
	mysqlInit bool
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
			err := pkg.UninstallServece(namespace,deploymentFile,kubeconfig,uninstallMiddlerware)
			if err != nil {
				fmt.Println(err)
				fmt.Println("         -------------卸载失败，请根据提示先检查-------------------")
			}else{
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
				pkg.Start(kubeconfig,namespace,configfile,deploymentFile,mysqlInit)
		},
	}
	//startCmd.Flags().BoolVarP(&daemon, "deamon", "d", false, "is daemon?")
	startCmd.Flags().StringVarP(&kubeconfig,"kubeconfig", "k","","kubeconfig绝对路径,如果kubeconfig文件不在～/.kube/config个路径下需要指定")
	startCmd.Flags().StringVarP(&configfile, "configfile", "c", "./configs/configs.yml", "配置文件路径")
	startCmd.Flags().StringVarP(&deploymentFile, "deploymentFile", "d", "./deployment", "部署服务（deployment文件夹相对或绝对路径）文件夹路径")
	startCmd.Flags().BoolVarP(&mysqlInit, "middlerwareInit", "i", false, "是否需要初始化mysql，初次安装需要指定")
	startCmd.Flags().StringVarP(&namespace,"namespace", "n","default","容器部署在k8s的命名空间,默认为default")
	rootCmd.AddCommand(startCmd)
	uninstallCmd.Flags().StringVarP(&namespace,"namespace", "n","default","容器部署在k8s的命名空间,默认为default")
	uninstallCmd.Flags().BoolVarP(&uninstallMiddlerware, "uninstallMiddlerware", "u", false, "是否需要卸载中间件（只有中间件是该工具部署的才可以指定）")
	uninstallCmd.Flags().StringVarP(&deploymentFile,"deploymentFile", "d","./deployment","部署服务（deployment文件夹相对或绝对路径）文件夹路径")
	uninstallCmd.Flags().StringVarP(&kubeconfig,"kubeconfig", "k","","kubeconfig绝对路径,如果kubeconfig文件不在～/.kube/config个路径下需要指定")
	rootCmd.AddCommand(uninstallCmd)


	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}