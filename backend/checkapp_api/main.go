package main

import (
	"checkapp_api/handlers"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/thinkerou/favicon"
)

// use a single instance of Validate, it caches struct info
var validate *validator.Validate

// https://github.com/Depado/gin-auth-example/blob/master/main.go

var secret = []byte("secret")

func main() {
	validate = validator.New()
	r := engine()
	r.Use(gin.Logger())
	if err := engine().Run(":8083"); err != nil {
		log.Fatal("Unable to start:", err)
	}
}

func engine() *gin.Engine {
	r := gin.New()

	// Setup the cookie store for session management
	r.Use(sessions.Sessions("mysession", sessions.NewCookieStore(secret)))
	// home
	r.Use(favicon.New("./assets/favicon.ico"))
	r.LoadHTMLGlob("templates/*.tmpl")
	r.StaticFile("/im1.jpg", "./assets/im1.jpg")
	r.GET("/", getHome)
	r.GET("/index", getHome)
	// Login and logout routes
	r.POST("/login", handlers.Login)
	r.GET("/logout", handlers.Logout)

	// user related endpoints
	users := r.Group("/users")
	{
		users.GET("", handlers.GetUsers)
		users.POST("", handlers.PostUser)
		users.GET("/:id", handlers.GetUserById)
	}
	r.GET("/companies", handlers.GetCompanies)
	r.GET("/companies/:id", handlers.GetCompanyById)

	qrs := r.Group("/qrs")
	{
		qrs.GET("", handlers.GetQrs)
		qrs.GET("/:id", handlers.GetQrById)
		qrs.GET("/image/:id", handlers.GetQrImageById)
	}

	// Private group, require authentication to access
	private := r.Group("/private")
	private.Use(handlers.AuthRequired)
	{
		private.GET("/qrs/generate/:id", handlers.GenerateQr)
		private.GET("/me", handlers.Me)
		private.GET("/status", handlers.Status)
		// private.POST("/attendance")
		// private.GET("/attendance/stats")
	}
	return r
}

func validateId(id_str string, c *gin.Context) int64 {
	id, err := strconv.ParseInt(id_str, 10, 64)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "invalid value for id: " + id_str})
	}
	return id
}

// func registerAttendance(c *gin.Context) {
// 	var user_id_field, company_id_field = "user_id", "company_id"
// 	user_id, err := utils.ValidateId(c.PostForm(user_id_field), user_id_field)
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{"error": "Error! " + err.Error()})
// 		return
// 	}

// 	company_id, err := utils.ValidateId(c.PostForm(company_id_field), company_id_field)
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{"error": "Error! " + err.Error()})
// 		return
// 	}
// 	// Check for username and password match, usually from a database
// 	user, err := controllers.GetUserById(user_id)
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{"error": "Error! " + err.Error()})
// 		return
// 	}
// 	if user.Company_id != int(company_id) {
// 		c.JSON(http.StatusBadRequest, gin.H{"error": "User does not belong to this company"})
// 		return
// 	}
// 	company, err := controllers.GetCompanyById(company_id)
// 	location := c.PostForm("location")
// 	km_distance := calculateDistance(location, company.Location, c)
// 	if km_distance > 0.5 {
// 		c.JSON(http.StatusForbidden,
// 			gin.H{
// 				"error":    "You are too far away from the registered spot",
// 				"distance": fmt.Sprintf("%f", km_distance) + " km"})

// 	}
// 	c.JSON(http.StatusOK, gin.H{
// 		"action":     "arrival",
// 		"registered": true,
// 		"datetime":   "214213412",
// 		"on_time":    true,
// 	})

// }

func getHome(c *gin.Context) {
	fmt.Println("sweet home")
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "tomando leche",
	})
}
