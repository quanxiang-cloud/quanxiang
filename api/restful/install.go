package restful

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"quanxiang/pkg"
)

type Install struct {
	Kubeconfig string `form:"kubeconfig" json:"kubeconfig" xml:"kubeconfig"  binding:"-"`
	Configfile string `form:"configfile" json:"configfile" xml:"configfile"  binding:"-"`
	DeploymentFile string `form:"deploymentFile" json:"deploymentFile" xml:"deploymentFile"  binding:"-"`
	MysqlInit bool `form:"mysqlInit" json:"mysqlInit" xml:"mysqlInit"  binding:"-"`
	NgGateWay bool `form:"ngGateWay" json:"ngGateWay" xml:"ngGateWay"  binding:"-"`
	Namespace string `form:"namespace" json:"namespace" xml:"namespace"  binding:"-"`
}

func (I *Install)StartInstall(c *gin.Context)  {
	if err := c.ShouldBind(I);err != nil{
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
	fmt.Println("             ********************************************************************************")
	fmt.Println("             *                                                                              *")
	fmt.Println("             *                                  部署程序开始运行                            *")
	fmt.Println("             *                                                                              *")
	fmt.Println("             ********************************************************************************")
	fmt.Println()
	pkg.Start(I.Kubeconfig,I.Namespace,I.Configfile,I.DeploymentFile,I.MysqlInit,I.NgGateWay)
}