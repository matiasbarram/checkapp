package attendance

import (
	"checkapp_api/controllers"
	"checkapp_api/models"
	"checkapp_api/utils"
	"log"
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
func GetCompanyMonthlyFromSession(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	attendances, err := controllers.GetMonthlyCompanyAttendance(int64(id))
	if err != nil {
		responseError, code := utils.GenerateResponseErrorWithCode(err)
		c.IndentedJSON(code, gin.H{"error": responseError})
	} else {
		c.JSON(http.StatusOK, attendances)
	}

}

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
func GetFilteredAttendanceFromSession(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	var queryFilter models.AttendanceQueryFilter
	if c.ShouldBind(&queryFilter) == nil {
		log.Println(queryFilter.Name)
		log.Println(queryFilter.From.Date())
		log.Println(queryFilter.To.Format("2006-01-02"))
		log.Println(queryFilter.Role)
	}
	attendances, err := controllers.GetFilteredCompanyAttendance(int64(id),
		queryFilter)
	if err != nil {
		responseError, code := utils.GenerateResponseErrorWithCode(err)
		c.IndentedJSON(code, gin.H{"error": responseError})
	} else {
		c.JSON(http.StatusOK, attendances)
	}

}
