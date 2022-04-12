package main

import (
	"checkapp_api/models"
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/thinkerou/favicon"
)

// use a single instance of Validate, it caches struct info
var validate *validator.Validate

// https://github.com/Depado/gin-auth-example/blob/master/main.go
const userkey = "user"

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
	r.POST("/login", login)
	r.GET("/logout", logout)

	// user related endpoints
	users := r.Group("/users")
	{
		users.GET("", getUsers)
		users.POST("", validateUser)
		users.GET("/:id", getUserById)
	}
	r.GET("/companies", getCompanies)
	r.GET("/companies/:id", getCompanyById)

	qrs := r.Group("/qrs")
	{
		qrs.GET("", getQrs)
		qrs.GET("/:id", getQrById)
		qrs.GET("/image/:id", getQrImageById)
	}

	// Private group, require authentication to access
	private := r.Group("/private")
	private.Use(AuthRequired)
	{
		private.GET("/qrs/generate/:id", generateQr)
		private.GET("/me", me)
		private.GET("/status", status)
	}
	return r
}

// AuthRequired is a simple middleware to check the session
func AuthRequired(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(userkey)
	if user == nil {
		// Abort the request with the appropriate error code
		c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// Continue down the chain to handler etc
	c.Next()
}

// login is a handler that parses a form and checks for specific data
func login(c *gin.Context) {
	session := sessions.Default(c)
	email := c.PostForm("email")
	password := c.PostForm("password")

	// Validate form input
	if strings.Trim(email, " ") == "" || strings.Trim(password, " ") == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Parameters can't be empty"})
		return
	}

	// Check for username and password match, usually from a database
	user, err := models.ValidateCredentials(email, password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Authentication failed " + err.Error()})
		return
	}
	// Save the username in the session
	session.Set(userkey, user.Id) // In real world usage you'd set this to the users ID
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save session"})
		return
	}
	user.Password = ""
	c.JSON(http.StatusOK, gin.H{"message": "Successfully authenticated ",
		"user": user})
}

func logout(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(userkey)
	if user == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid session token"})
		return
	}
	session.Delete(userkey)
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save session"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Successfully logged out"})
}

func me(c *gin.Context) {
	session := sessions.Default(c)
	user := session.Get(userkey)
	c.JSON(http.StatusOK, gin.H{"user": user})
}

func status(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "You are logged in"})
}

func validateUser(c *gin.Context) {

	var u models.User
	err := c.ShouldBindJSON(&u)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			c.JSON(http.StatusBadRequest, gin.H{"errors": Simple(verr)})
			return
		}
	}
	user, err := models.PostUser(u)
	if err != nil {
		fmt.Println("error ", err.Error())
		// ver los posibles errores y responder acorde
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "User registration successful.",
			"user": user})
	}
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
