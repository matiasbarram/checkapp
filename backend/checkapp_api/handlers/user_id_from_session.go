package handlers

import (
	"checkapp_api/data"
	"net/http"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

func Me(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(data.UserKey)
	c.JSON(http.StatusOK, gin.H{"user": user})
}
