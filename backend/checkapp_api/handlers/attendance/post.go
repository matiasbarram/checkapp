package attendance

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary                    registers attendance for current user
// @Schemes                    https
// @Description                lol
// @Tags                       /attendance
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Param                      data  body  models.AttendanceParams  true  "The input Attendance struct"
// @Accept                     json
// @Success                    200  {object}  models.AttendanceResponse
// @Failure                    400  {object}  models.SimpleError
// @Failure                    404  {object}  models.SimpleError
// @Failure                    500  {object}  models.SimpleError
// @Router                     /private/attendance [post]
func Post(c *gin.Context) {
	userId, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusUnauthorized, gin.H{"message": "algo malio sal"})
	}
	att, err := utils.ValidateAttendanceParams(c)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	attendance, err := controllers.NewRegisterAttendance(att, int64(userId))
	if err != nil {
		responseError := utils.GenerateResponseError(err)
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": responseError})
	} else {
		c.JSON(http.StatusOK, gin.H{"attendance": attendance})
	}
}
