package utils

import (
	"checkapp_api/data"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

func GetUserIdFromSession(c *gin.Context) (int, bool) {
	session := sessions.Default(c)
	sessionId := session.Get(data.UserKey)
	userId, ok := sessionId.(int)
	return userId, ok
}