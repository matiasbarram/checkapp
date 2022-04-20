package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"net/http"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
)

func GetMyAttendance(c *gin.Context) {
	session := sessions.Default(c)
	sessionId := session.Get(data.UserKey)
	id, ok := sessionId.(int)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	attendances, err := controllers.GetAttendanceFromUser(int64(id))

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, attendances)
	}
}
