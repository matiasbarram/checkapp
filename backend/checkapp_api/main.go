package main

import (
	"checkapp_api/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/thinkerou/favicon"
)

func main() {
	router := gin.Default()
	router.Use(favicon.New("./assets/favicon.ico"))
	router.StaticFile("/im1.jpg", "./assets/im1.jpg")
	router.LoadHTMLGlob("templates/*.tmpl")
	router.GET("/", getHome)
	router.GET("/index", getHome)
	router.GET("/users", getUsers)
	router.GET("/users/:id", getUserById)
	router.GET("/companies", getCompanies)
	router.GET("/companies/:id", getCompanyById)
	router.GET("/qrs", getQrs)
	router.GET("/qrs/:id", getQrById)
	router.GET("/qrs/generate/:id", generateQr)
	router.GET("/qrs/image/:id", getQrImageById)
	// router.GET("/product/:code", getProduct)
	// router.POST("/users", addProduct)
	router.Run("localhost:8083")
}

func getHome(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "tomando leche",
	})
}

func getUsers(c *gin.Context) {
	users := models.GetUsers()

	if users == nil || len(users) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, users)
	}
}

func getUserById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	user, err := models.GetUserById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "user not found"})
	} else {
		c.IndentedJSON(http.StatusOK, user)
	}
}

func getCompanies(c *gin.Context) {
	companies := models.GetCompanies()

	if companies == nil || len(companies) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, companies)
	}
}

func getCompanyById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	company, err := models.GetCompanyById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "Company not found"})
	} else {
		c.IndentedJSON(http.StatusOK, company)
	}
}

func getQrs(c *gin.Context) {
	qrs := models.GetQrs()

	if qrs == nil || len(qrs) == 0 {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.IndentedJSON(http.StatusOK, qrs)
	}
}

func getQrById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := models.GetQrById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "QR not found"})
	} else {
		c.IndentedJSON(http.StatusOK, qr)
	}
}

func getQrImageById(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := models.GetQrImageById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "QR not found"})
	} else {
		c.Data(http.StatusOK, "image/jpeg", qr)
	}
}

func generateQr(c *gin.Context) {
	str_id := c.Param("id")
	id, err := strconv.ParseInt(str_id, 10, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	qr, err := models.GenerateQr(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, qr)
	}
}
