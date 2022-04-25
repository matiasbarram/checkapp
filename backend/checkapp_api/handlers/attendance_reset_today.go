package handlers

import (
	"checkapp_api/controllers"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      clear u
// @Schemes      https
// @Description  show api homepage
// @Tags         /private/attendance/last
// @securityDefinitions.basic BasicAuth
// @Produce      json
// @Success 200 {object} models.Attendance
// @Failure      400  {object}  models.SimpleError
// @Failure      404  {object}  models.SimpleError
// @Failure      500  {object}  models.SimpleError
// @Router       /reset/attendance/today [get]
func ResetTodaysAttendance(c *gin.Context) {
	err := controllers.ResetTodayAttendance()
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, gin.H{"message": "okie"})
	}
}
