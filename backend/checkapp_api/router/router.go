package router

import (
	"checkapp_api/data"
	"checkapp_api/handlers"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	"github.com/thinkerou/favicon"
)

func Setup() *gin.Engine {
	r := gin.New()

	// Setup the cookie store for session management
	r.Use(sessions.Sessions("mysession", sessions.NewCookieStore(data.Secret)))
	// home
	r.Use(favicon.New("./assets/favicon.ico"))
	//logger
	r.Use(gin.Logger())
	r.LoadHTMLGlob("templates/*.tmpl")
	r.StaticFile("/im1.jpg", "./assets/im1.jpg")
	r.GET("/", handlers.GetHome)
	r.GET("/index", handlers.GetHome)
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
		private.GET("/companies/generate/:id", handlers.GenerateQr)
		private.GET("/me", handlers.Me)
		// private.POST("/attendance")
		// private.GET("/attendance/stats")
	}
	return r
}
