package user

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"checkapp_api/utils"
	"database/sql"
	"net/http"
	"strconv"

	"github.com/WAY29/icecream-go/icecream"
	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

// TODO: cambiar la forma de obtner la id from session

// HealthCheck godoc
// @Summary      retrieves all users (pagination pending)
// @Schemes      https
// @Description  lol
// @Tags         /users
// @Produce      json
// @Accept       json
// @Success      200  {array}   models.User
// @Failure      400  {object}  models.SimpleError
// @Router       /private/users [get]
func GetAll(c *gin.Context) {
	users := controllers.GetUsers()

	c.IndentedJSON(http.StatusOK, users)
}

// HealthCheck godoc
// @Summary      retrieves user by id
// @Schemes      https
// @Description  lol
// @Tags        /users/{id}
// @Produce      json
// @Param        int  path      int  true  "int valid"  minimum(1)
// @Success      200  {array}   models.User
// @Failure      404  {object}  models.SimpleError
// @Router       /private/users/{id} [get]
func GetById(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusUnauthorized, gin.H{"message": "xd"})
	}
	getUserById(c, id)
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves authenticated user's info
// @Schemes      https
// @Description  lol
// @Tags         /me
// @Produce      json
// @Param        int  path      int  true  "int valid"  minimum(1)
// @Success      200  {array}   models.User
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

func GetPictureById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	img, err := controllers.GetUserPicture(id)
	if err != nil && err != sql.ErrNoRows {
		c.AbortWithStatus(http.StatusInternalServerError)
	} else if err == sql.ErrNoRows {
		icecream.Ic(err.Error())
		c.AbortWithStatus(http.StatusNotFound)
	} else if len(img) == 0 {
		c.Redirect(http.StatusTemporaryRedirect, "/api/v1/im2.png")
	}
	c.Data(http.StatusOK, "image/jpeg", img)
}
