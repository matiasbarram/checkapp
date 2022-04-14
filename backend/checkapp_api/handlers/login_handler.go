package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"checkapp_api/models"
	"checkapp_api/utils"
	"errors"
	"net/http"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

// AuthRequired is a simple middleware to check the session
func AuthRequired(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(data.UserKey)
	if user == nil {
		// Abort the request with the appropriate error code
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// Continue down the chain to handler etc
	c.Next()
}

// login is a handler that parses a form and checks for specific data
func Login(c *gin.Context) {
	session := sessions.Default(c)
	var u models.UserCredentials
	err := c.ShouldBindJSON(&u)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			c.JSON(http.StatusBadRequest, gin.H{"errors": utils.SimpleValidationErrors(verr)})
			return
		}
	}

	// Check for username and password match, usually from a database
	user, err := controllers.ValidateCredentials(u)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Authentication failed " + err.Error()})
		return
	}
	// Save the username in the session
	session.Set(data.UserKey, user.Id) // In real world usage you'd set this to the users ID
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save session"})
		return
	}
	user.Password = ""
	// c.IndentedJSON(http.StatusOK, user)
	c.JSON(http.StatusOK, gin.H{"message": "Successfully logged in",
		"user": user})
}

func Logout(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(data.UserKey)
	if user == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid session token"})
		return
	}
	session.Delete(data.UserKey)
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save session"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Successfully logged out"})
}

func Status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "You are logged in"})
}
