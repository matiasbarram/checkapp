package main

import (
	"checkapp_api/controllers"
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
	geo "github.com/kellydunn/golang-geo"
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
		// private.POST("/attendance")
		// private.GET("/attendance/stats")
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

func validateId(id_str string, c *gin.Context) int64 {
	id, err := strconv.ParseInt(id_str, 10, 64)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "invalid value for id: " + id_str})
	}
	return id
}

func getCoordinates(location string) (float64, float64, error) {
	var x float64
	var y float64
	if len(location) != 2 {
		return x, y, errors.New("Invalid location: " + location)
	}
	coord := strings.Split(strings.ReplaceAll(location, " ", ""), ",")
	x, err := strconv.ParseFloat(coord[0], 64)
	if err != nil {
		return x, y, err
	}
	y, err = strconv.ParseFloat(coord[1], 64)
	if err != nil {
		return x, y, err
	}
	return x, y, nil
}

func calculateDistance(user_location string, company_location string, c *gin.Context) float64 {
	ux, uy, err := getCoordinates(user_location)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "invalid value for user_location: " + user_location})
	}
	cx, cy, err := getCoordinates(company_location)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "invalid value for company_location: " + company_location})
	}
	up := geo.NewPoint(ux, uy)
	cp := geo.NewPoint(cx, cy)

	// find the great circle distance between them
	dist := up.GreatCircleDistance(cp)
	return dist
}

func registerAttendance(c *gin.Context) {
	user_id_str := c.PostForm("user_id")
	user_id := validateId(user_id_str, c)

	company_id_str := c.PostForm("company_id")
	company_id := validateId(company_id_str, c)

	// Check for username and password match, usually from a database
	user, err := controllers.GetUserById(user_id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error! " + err.Error()})
		return
	}
	if user.Company_id != int(company_id) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "User does not belong to this company"})
		return
	}
	company, err := controllers.GetCompanyById(company_id)
	location := c.PostForm("location")
	km_distance := calculateDistance(location, company.Location, c)
	if km_distance > 0.5 {
		c.JSON(http.StatusForbidden,
			gin.H{
				"error":    "You are too far away from the registered spot",
				"distance": fmt.Sprintf("%f", km_distance) + " km"})

	}
	c.JSON(http.StatusOK, gin.H{
		"action":     "arrival",
		"registered": true,
		"datetime":   "214213412",
		"on_time":    true,
	})

}

// login is a handler that parses a form and checks for specific data
func login(c *gin.Context) {
	session := sessions.Default(c)
	var u models.UserCredentials
	err := c.ShouldBindJSON(&u)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			c.JSON(http.StatusBadRequest, gin.H{"errors": Simple(verr)})
			return
		}
	}

	// Check for username and password match, usually from a database
	user, err := controllers.ValidateCredentials(u)
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
	// c.IndentedJSON(http.StatusOK, user)
	c.JSON(http.StatusOK, gin.H{"message": "Successfully logged in",
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
	// validar de mejor forma...
	if len(u.Password) < 4 {
		c.JSON(http.StatusBadRequest, gin.H{"errors": "password too short"})
		return
	}
	user, err := controllers.PostUser(u)
	if err != nil {
		fmt.Println("error ", err.Error())
		// ver los posibles errores y responder acorde
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	} else {
		user.Password = ""
		c.JSON(http.StatusOK, gin.H{"message": "registrao de pana.",
			"user": user})
	}
}

func getHome(c *gin.Context) {
	fmt.Println("sweet home")
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "tomando leche",
	})
}

func getUsers(c *gin.Context) {
	users := controllers.GetUsers()

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
	user, err := controllers.GetUserById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "user not found"})
	} else {
		c.IndentedJSON(http.StatusOK, user)
	}
}

func getCompanies(c *gin.Context) {
	companies := controllers.GetCompanies()

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
	company, err := controllers.GetCompanyById(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "Company not found"})
	} else {
		c.IndentedJSON(http.StatusOK, company)
	}
}

func getQrs(c *gin.Context) {
	qrs := controllers.GetQrs()

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
	qr, err := controllers.GetQrById(id)

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
	qr, err := controllers.GetQrImageById(id)

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
	qr, err := controllers.GenerateQr(id)

	if err != nil {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": err.Error()})
	} else {
		c.IndentedJSON(http.StatusOK, qr)
	}
}
