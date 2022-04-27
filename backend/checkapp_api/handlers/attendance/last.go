package attendance

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary                    returns current user's last attendance event
// @Schemes                    https
// @Description                show api homepage
// @Tags                       /attendance/last
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Success                    200  {object}  models.Attendance
// @Failure                    400  {object}  models.SimpleError
// @Failure                    404  {object}  models.SimpleError
// @Failure                    500  {object}  models.SimpleError
// @Router                     /private/attendance/last [get]
func GetLastFromSession(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	user, err := controllers.GetLastEventFromUser(int64(id))

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, user)
	}
}
