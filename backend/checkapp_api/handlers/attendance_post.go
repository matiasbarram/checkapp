package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      registers attendance for current user
// @Schemes      https
// @Description  lol
// @Tags         /private/attendance
// @securityDefinitions.basic BasicAuth
// @Produce      json
// @Param  data body models.AttendanceParams true "The input Attendance struct"
// @Accept json
// @Success 200 {object} models.Attendance
// @Failure      400  {object}  models.SimpleError
// @Failure      404  {object}  models.SimpleError
// @Failure      500  {object}  models.SimpleError
// @Router       /private/attendance [post]
func PostAttendance(c *gin.Context) {

	att, err := utils.ValidateAttendanceInfo(c)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	}

	attendance, err := controllers.RegisterAttendance(att)
	if err != nil {
		fmt.Println("error ", err.Error())
		// ver los posibles errores y responder acorde
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "markste tu entrada/salida",
			"attendance": attendance})
	}
}
