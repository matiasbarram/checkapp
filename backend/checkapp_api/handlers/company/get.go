package company

// package handlers

import (
	"checkapp_api/controllers"
	"checkapp_api/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves single company by id
// @Schemes      https
// @Description  lol
// @Tags         /companies/{id}
// @Produce      json
// @Accept json
// @Success 200  {array} models.Company
// @Failure      400  {object}  models.SimpleError
// @Router       /private/companies/{id} [get]
func GetAll(c *gin.Context) {

	companies := controllers.GetCompanies()
	c.IndentedJSON(http.StatusOK, companies)
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves single company by id
// @Schemes      https
// @Description  lol
// @Tags         /companies/{id}
// @Produce      json
// @Accept json
// @Success 200  models.Company
// @Failure      400  {object}  models.SimpleError
// @Router       /private/companies/{id} [get]
func GetById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	getById(c, id)
}

// @BasePath /api/v1

// HealthCheck godoc
// @Summary      retrieves current user's company (pagination pending)
// @Schemes      https
// @Description  lol
// @Tags         /companiess
// @Produce      json
// @Accept json
// @Success 200 {array} models.companies
// @Failure      400  {object}  models.SimpleError
// @Router       /private/companiess [get]
func GetFromSession(c *gin.Context) {
	id, ok := utils.GetUserIdFromSession(c)
	if !ok {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "algo malio sal"})
	}
	getByUserId(c, int64(id))
}

func getById(c *gin.Context, id int64) {
	company, err := controllers.GetCompanyById(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, company)
	}
}
func getByUserId(c *gin.Context, id int64) {
	company, err := controllers.GetCompanyByUserId(id)
	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, company)
	}
}
