package attendance

// package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary  returns current user's today's attendance
// @Schemes  https
// @Description
// @Tags                       /attendance/today
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Success                    200  {object}  models.AttendanceResponse
// @Failure                    400  {object}  models.SimpleError
// @Failure                    404  {object}  models.SimpleError
// @Failure                    500  {object}  models.SimpleError
// @Router                     /private/attendance/today [get]
func GetDailyFromSession(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	attendances, err := controllers.GetTodaysAttendance(int64(id))
	if err != nil {
		responseError := utils.GenerateResponseError(err)
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": responseError})
	} else {
		c.JSON(http.StatusOK, attendances)
	}
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary  generate current user's today's attendance
// @Schemes  https
// @Description
// @Tags                       /attendance/today/generate
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Success                    200  {array}  models.AttendanceResponse
// @Failure                    400  {object}  models.SimpleError
// @Failure                    404  {object}  models.SimpleError
// @Failure                    500  {object}  models.SimpleError
// @Router                     /private/attendance/today/generate [get]
// func GenerateDaily(c *gin.Context) {
// 	id, ok := utils.GetUserIdFromSession(c)
// 	if !ok {
// 		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
// 	}
// 	attendances, err := controllers.GenerateUserDailyAttendances(int64(id))

// 	if err != nil {
// 		responseError := utils.GenerateResponseError(err)
// 		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": responseError})
// 		return
// 	}
// 	c.IndentedJSON(http.StatusOK, attendances)
// }
