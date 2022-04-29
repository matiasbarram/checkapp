package qr

import (
	"checkapp_api/controllers"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GenerateQr(c *gin.Context) {
	str_id := c.Param("id")
	companyId, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := controllers.GenerateQr(companyId)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, qr)
	}
}
