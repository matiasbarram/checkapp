package attendance

// package handlers

import (
	"checkapp_api/controllers"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary                    clear u
// @Schemes                    https
// @Description                show api homepage
// @Tags                       /reset/attendance/last
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Success                    200
// @Router                     /reset/attendance/today [get]
func DeleteDaily(c *gin.Context) {
	err := controllers.ResetTodayAttendance()
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, gin.H{"message": "okie"})
	}
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary                    returns current user's last attendance event
// @Schemes                    https
// @Description                show api homepage
// @Tags                       /reset/attendance/last
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Success                    200
// @Router                     /reset/attendance/last [get]
func DeleteAll(c *gin.Context) {
	err := controllers.ResetAllAttendance()
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, gin.H{"message": "okie"})
	}
}
