package qr

import (
	"checkapp_api/controllers"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves all qrs (pagination pending)
// @Schemes      https
// @Description  lol
// @Tags         /qrs
// @Produce      json
// @Accept       json
// @Success      200  {array}   models.Qr
// @Failure      400  {object}  models.SimpleError
// @Router       /private/qrs [get]
func GetAll(c *gin.Context) {
	qrs := controllers.GetQrs()

	if len(qrs) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, qrs)
	}
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves qr by id
// @Schemes      https
// @Description  lol
// @Tags         /qrs/{id}
// @Produce      json
// @Param        int  path      int  true  "int valid"  minimum(1)
// @Success      200  {array}   models.Qr
// @Failure      404  {object}  models.SimpleError
// @Router       /private/qrs/{id} [get]
func GetById(c *gin.Context) {
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

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves qr image by id
// @Schemes      https
// @Description  lol
// @Tags         /qrs/image/{id}
// @Produce      json
// @Param        int  path      int  true  "int valid"  minimum(1)
// @Success      200  {array}   models.Qr
// @Failure      404  {object}  models.SimpleError
// @Router       /private/qrs/image/{id} [get]
func GetImageById(c *gin.Context) {
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
