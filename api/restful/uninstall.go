package restful

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"quanxiang/pkg"
)

type UnInstall struct {
	Kubeconfig string `form:"kubeconfig" json:"kubeconfig" xml:"kubeconfig"  binding:"-"`
	DeploymentFile string `form:"deploymentFile" json:"deploymentFile" xml:"deploymentFile"  binding:"-"`
	UninstallMiddlerware bool `form:"uninstallMiddlerware" json:"uninstallMiddlerware" xml:"uninstallMiddlerware"  binding:"-"`
	Namespace string `form:"namespace" json:"namespace" xml:"namespace"  binding:"-"`
}

func (U UnInstall)StartUnInstall(c *gin.Context)  {
	if err := c.ShouldBind(U);err != nil{
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
	fmt.Println("             ********************************************************************************")
	fmt.Println("             *                                                                              *")
	fmt.Println("             *                                  卸载程序开始运行                            *")
	fmt.Println("             *                                                                              *")
	fmt.Println("             ********************************************************************************")
	fmt.Println()
	err := pkg.UninstallServece(U.Namespace,U.DeploymentFile,U.Kubeconfig,U.UninstallMiddlerware)
	if err != nil {
		fmt.Println(err)
		fmt.Println("         -------------卸载失败，请根据提示先检查-------------------")
	}else{
		fmt.Println("         -------------卸载成功，如部署请使用start命令-------------------")
	}
}