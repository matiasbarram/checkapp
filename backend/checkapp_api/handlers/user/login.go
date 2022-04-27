package user

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"checkapp_api/utils"
	"net/http"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

// login is a handler that parses a form and checks for specific data
// @BasePath /api/v1

// HealthCheck godoc
// @Summary      basic login
// @Schemes      https
// @Description  lol
// @Tags         /login
// @securityDefinitions.basic BasicAuth
// @Produce      json
// @Param  data body models.UserCredentials true "user credentials (email and password)"
// @Accept json
// @Success 200 {object} models.UserLoginResponse
// @Failure      400  {object}  models.SimpleError
// @Failure      401  {object}  models.SimpleError
// @Router       /login [post]
func Login(c *gin.Context) {
	u, err := utils.ValidateLoginArgs(c)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}
	// Check for username and password match, usually from a database
	user, err := controllers.ValidateCredentials(u)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Authentication failed " + err.Error()})
		return
	}
	session := sessions.Default(c)
	// Save the username in the session
	session.Set(data.UserKey, user.Id) // In real world usage you'd set this to the users ID
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save session"})
		return
	}
	// drop password
	user.Password = ""
	// c.IndentedJSON(http.StatusOK, user)
	c.JSON(http.StatusOK, gin.H{"message": "Successfully logged in",
		"user": user})
}
