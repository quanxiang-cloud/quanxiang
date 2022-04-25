package restful

import (
	"github.com/gin-gonic/gin"
	"git.internal.yunify.com/qxp/misc/logger"
)
type Router struct {
	engine *gin.Engine
}


func newRouter() (*gin.Engine, error) {
	gin.SetMode(gin.ReleaseMode)
	engine := gin.New()

	engine.Use(logger.GinLogger(),
		logger.GinRecovery())

	return engine, nil
}

func NewRouter() (*Router, error) {
	engine, err := newRouter()
	if err != nil {
		return nil, err
	}
	installqxp := Install{}
	uninstallqxp := UnInstall{}
	engine.POST("/install",installqxp.StartInstall)
	engine.POST("/uninstall",uninstallqxp.StartUnInstall)
	return &Router{
		engine:        engine,
	}, nil
}

// Run 启动服务
func (r *Router) Run() {
	r.engine.Run(":8089")
}
// Close 关闭服务
func (r *Router) Close() {
}