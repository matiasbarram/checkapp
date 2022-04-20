package router

import (
	"checkapp_api/data"
	"checkapp_api/handlers"

	docs "checkapp_api/docs"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"github.com/thinkerou/favicon"
)

func Setup() *gin.Engine {
	r := gin.New()

	// Setup the cookie store for session management
	r.Use(sessions.Sessions("mysession", sessions.NewCookieStore(data.Secret)))
	//logger
	r.Use(gin.Logger())
	// home
	r.Use(favicon.New("./assets/favicon.ico"))
	r.LoadHTMLGlob("templates/*.tmpl")

	// swagger
	docs.SwaggerInfo.BasePath = "/api/v1"
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))

	v1 := r.Group("/api/v1")
	{
		v1.StaticFile("/im1.jpg", "./assets/im1.jpg")
		v1.GET("/", handlers.GetHome)
		v1.GET("/index", handlers.GetHome)
		v1.GET("/home", handlers.GetHome)
		// Login and logout routes
		v1.POST("/login", handlers.Login)
		v1.GET("/logout", handlers.Logout)

		// user related endpoints
		users := v1.Group("/users")
		{
			users.GET("", handlers.GetUsers)
			users.POST("", handlers.PostUser)
			users.GET("/:id", handlers.GetUserById)
		}

		companies := v1.Group("/companies")
		{
			companies.GET("", handlers.GetCompanies)
			companies.GET("/:id", handlers.GetCompanyById)
		}

		qrs := v1.Group("/qrs")
		{
			qrs.GET("", handlers.GetQrs)
			qrs.GET("/:id", handlers.GetQrById)
			qrs.GET("/image/:id", handlers.GetQrImageById)
		}

		// Private group, require authentication to access
		private := v1.Group("/private")
		private.Use(handlers.AuthRequired)
		{
			private.GET("/companies/generate/:id", handlers.GenerateQr)
			private.GET("/me", handlers.Me)
			private.GET("/attendance", handlers.GetMyAttendance)
			private.POST("/attendance", handlers.PostAttendance)
			private.GET("/attendance/last", handlers.GetMyLastAttendance)
			// private.GET("/attendance/stats")
		}
	}
	return r
}
