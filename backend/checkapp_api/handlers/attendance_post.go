package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/models"
	"checkapp_api/utils"
	"errors"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
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

	// var att models.AttendanceParams
	var attParams models.AttendanceParams
	attParams.Event_type = "NEXT"
	err := c.BindJSON(&attParams)
	if err != nil {
		log.Fatal(err)
	}
	// err = c.BindJSON(&att)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			c.JSON(http.StatusBadRequest, gin.H{"errors": utils.SimpleValidationErrors(verr)})
			return
		}
	}

	attendance, err := controllers.RegisterAttendance(attParams)
	if err != nil {
		fmt.Println("error ", err.Error())
		// ver los posibles errores y responder acorde
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "markste tu entrada/salida",
			"attendance": attendance})
	}
}
