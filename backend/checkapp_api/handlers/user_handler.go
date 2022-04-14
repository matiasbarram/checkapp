package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"checkapp_api/models"
	"checkapp_api/utils"
	"errors"
	"fmt"
	"net/http"
	"net/mail"
	"strconv"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

func Me(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(data.UserKey)
	c.JSON(http.StatusOK, gin.H{"user": user})
}

func GetUsers(c *gin.Context) {
	users := controllers.GetUsers()

	if users == nil || len(users) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, users)
	}
}

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

func PostUser(c *gin.Context) {
	u, err := ValidateUserInfo(c)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
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

func ValidateUserInfo(c *gin.Context) (models.User, error) {
	var u models.User
	err := c.ShouldBindJSON(&u)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			return u, errors.New(fmt.Sprint(utils.SimpleValidationErrors(verr)))
		}
	}
	// validar de mejor forma...
	if len(u.Password) < 4 {
		return u, errors.New("password too short")
	}
	_, err = mail.ParseAddress(u.Email)
	if err != nil {
		return u, err
	}
	return u, nil
}
