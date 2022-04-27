package user

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"net/http"
	"strconv"

	"github.com/gin-gonic/contrib/sessions"
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
func GetAll(c *gin.Context) {
	users := controllers.GetUsers()

	if len(users) == 0 {
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
func GetById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	getUserById(c, id)

}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves authenticated user's info
// @Schemes      https
// @Description  lol
// @Tags         /private/me
// @Produce      json
// @Param  int path int true "int valid" minimum(1)
// @Success 200 {array} models.User
// @Failure      404  {object}  models.SimpleError
// @Router       /private/me [get]
func GetFromSession(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(data.UserKey)
	id := user.(int)
	getUserById(c, int64(id))

}

//helper func
func getUserById(c *gin.Context, id int64) {
	user, err := controllers.GetUserById(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "user not found"})
	} else {
		c.IndentedJSON(http.StatusOK, user)
	}
}
