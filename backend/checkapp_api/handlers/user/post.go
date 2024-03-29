package user

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary                    creates a new user
// @Schemes                    https
// @Description                lol
// @Tags                       /users
// @securityDefinitions.basic  BasicAuth
// @Produce                    json
// @Param                      data  body  models.User  true  "The input User struct"
// @Accept                     json
// @Success                    200  {object}  models.User
// @Failure                    400  {object}  models.SimpleError
// @Router                     /private/users [post]
func Post(c *gin.Context) {
	u, err, resp := utils.ValidateUserInfo(c)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, resp)
		return
	}
	user, err := controllers.PostUser(u)
	if err != nil {
		fmt.Println("error ", err.Error())
		// ver los posibles errores y responder acorde
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	} else {
		user.Password = ""
		c.JSON(http.StatusOK, gin.H{"message": "registrao de pana.",
			"user": user})
	}
}
