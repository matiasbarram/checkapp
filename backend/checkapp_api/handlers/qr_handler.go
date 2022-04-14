package handlers

import (
	"checkapp_api/controllers"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetQrs(c *gin.Context) {
	qrs := controllers.GetQrs()

	if qrs == nil || len(qrs) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, qrs)
	}
}

func GetQrById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := controllers.GetQrById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "QR not found"})
	} else {
		c.IndentedJSON(http.StatusOK, qr)
	}
}

func GetQrImageById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := controllers.GetQrImageById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "QR not found"})
	} else {
		c.Data(http.StatusOK, "image/jpeg", qr)
	}
}

func GenerateQr(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := controllers.GenerateQr(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, qr)
	}
}
