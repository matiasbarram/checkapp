package handlers

import (
	"checkapp_api/controllers"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetCompanies(c *gin.Context) {
	companies := controllers.GetCompanies()

	if companies == nil || len(companies) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, companies)
	}
}

func GetCompanyById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	company, err := controllers.GetCompanyById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "Company not found"})
	} else {
		c.IndentedJSON(http.StatusOK, company)
	}
}
