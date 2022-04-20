package handlers

import (
	"checkapp_api/controllers"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves all users (pagination pending)
// @Schemes      https
// @Description  lol
// @Tags         /users
// @Produce      json
// @Accept json
// @Success 200 {array} models.User
// @Failure      400  {object}  models.SimpleError
// @Router       /users [get]
func GetUsers(c *gin.Context) {
	users := controllers.GetUsers()

	if users == nil || len(users) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, users)
	}
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves user by id
// @Schemes      https
// @Description  lol
// @Tags         /users/{id}
// @Produce      json
// @Param  int path int true "int valid" minimum(1)
// @Success 200 {array} models.User
// @Failure      404  {object}  models.SimpleError
// @Router       /users/{id} [get]
func GetUserById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	user, err := controllers.GetUserById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "user not found"})
	} else {
		c.IndentedJSON(http.StatusOK, user)
	}
}
