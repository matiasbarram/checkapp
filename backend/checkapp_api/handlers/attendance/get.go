package attendance

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// HealthCheck godoc
// @Summary      retrieves all attendances (pagination pending)
// @Schemes      https
// @Description  lol
// @Tags         /attendances
// @Produce      json
// @Accept       json
// @Success      200  {array}   models.Attendance
// @Failure      400  {object}  models.SimpleError
// @Router       /private/attendances [get]
func GetAll(c *gin.Context) {
	attendances, err := controllers.GetAttendances()
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}
	c.IndentedJSON(http.StatusOK, attendances)
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves single attendance by id
// @Schemes      https
// @Description  lol
// @Tags         /attendances/{id}
// @Produce      json
// @Accept       json
// @Success      200  {object}  models.Attendance
// @Failure      400  {object}  models.SimpleError
// @Router       /private/attendances/{id} [get]
func GetById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	getById(c, id)
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves current user's attendances (pagination pending)
// @Schemes      https
// @Description  lol
// @Tags         /attendances
// @Produce      json
// @Accept       json
// @Success      200  {array}   models.Attendance
// @Failure      400  {object}  models.SimpleError
// @Router       /private/attendances/me [get]
func GetFromSession(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	getByUserId(c, int64(id))
}

func getById(c *gin.Context, id int64) {
	attendances, err := controllers.GetAttendanceById(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, attendances)
	}
}
func getByUserId(c *gin.Context, id int64) {
	attendances, err := controllers.GetAttendanceFromUser(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, attendances)
	}
}
