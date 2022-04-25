package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      returns current user's today's attendance
// @Schemes      https
// @Description
// @Tags         /private/attendance/today
// @securityDefinitions.basic BasicAuth
// @Produce      json
// @Success 200 {object} models.AttendanceResponse
// @Failure      400  {object}  models.SimpleError
// @Failure      404  {object}  models.SimpleError
// @Failure      500  {object}  models.SimpleError
// @Router       /private/attendance/today [get]
func GetTodaysAttendance(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	attendances, err := controllers.GetTodaysAttendance(int64(id))
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "Unexpected error! " + err.Error()})
		return
	}
	c.IndentedJSON(http.StatusOK, attendances)
}
