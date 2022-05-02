package user

import (
	"checkapp_api/controllers"
	"checkapp_api/models"
	"checkapp_api/utils"
	"io/ioutil"
	"net/http"

	"github.com/gin-gonic/gin"
)

func PutImageFromUrl(c *gin.Context) {

	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}

	var url models.UserImage
	err := c.ShouldBind(&url)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "pesima tu img"})
	}
	response, err := http.Get(url.Url)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "pesima tu img"})
	}
	defer response.Body.Close()
	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "pesima tu img"})
	}
	user, err := controllers.PutUserPicture(int64(id), responseData)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "pesima tu img"})
	}
	c.IndentedJSON(http.StatusOK, user)

}
