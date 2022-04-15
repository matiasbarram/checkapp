package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func PostUser(c *gin.Context) {
	u, err := utils.ValidateUserInfo(c)
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
