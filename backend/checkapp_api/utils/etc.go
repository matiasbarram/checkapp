package utils

import (
	"checkapp_api/data"
	"strings"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

func GetUserIdFromSession(c *gin.Context) (int, bool) {
	session := sessions.Default(c)
	sessionId := session.Get(data.UserKey)
	userId, ok := sessionId.(int)
	return userId, ok
}

func SplitComments(comments string) (string, string) {
	x := strings.Split(comments, ",")
	return x[0], x[1]
}

func Reverse(s []interface{}) []interface{} {
	a := make([]interface{}, len(s))
	copy(a, s)

	for i := len(a)/2 - 1; i >= 0; i-- {
		opp := len(a) - 1 - i
		a[i], a[opp] = a[opp], a[i]
	}

	return a
}
