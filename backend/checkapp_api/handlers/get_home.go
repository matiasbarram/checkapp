package handlers

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      api homepage
// @Schemes      https
// @Description  show api homepage
// @Tags         home
// @Produce      html
// @Success      200  {string}  tomando  leche
// @Router       / [get]
func GetHome(c *gin.Context) {
	fmt.Println("sweet home")
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "tomando leche",
	})
}
