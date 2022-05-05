package router

import (
	"checkapp_api/data"
	"checkapp_api/handlers"
	"checkapp_api/handlers/attendance"
	"checkapp_api/handlers/company"
	"checkapp_api/handlers/qr"
	"checkapp_api/handlers/user"
	"net/http"

	docs "checkapp_api/docs"

	"github.com/gin-gonic/contrib/sessions"
	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"github.com/thinkerou/favicon"
)

func addUserGroupEndpoints(baseGroup *gin.RouterGroup) {
	// user related endpoints
	userGroup := baseGroup.Group("/users")
	{
		userGroup.GET("", user.GetAll)
		userGroup.POST("", user.Post)
		userGroup.GET("/:id", user.GetById)
		userGroup.GET("/me", user.GetFromSession)
		userGroup.PUT("/image", user.PutImageFromUrl)
	}

}

func addAttendanceGroupEndpoints(baseGroup *gin.RouterGroup) {
	// user related endpoints
	attendanceGroup := baseGroup.Group("/attendance")
	{
		attendanceGroup.POST("", attendance.Post)
		attendanceGroup.GET("", attendance.GetAll)
		attendanceGroup.GET("/:id", attendance.GetById)
		attendanceGroup.GET("/me", attendance.GetFromSession)
		attendanceGroup.GET("/last", attendance.GetLastFromSession) // borrable
		attendanceGroup.GET("/today", attendance.GetDailyFromSession)
		attendanceGroup.GET("/company/monthly", attendance.GetCompanyMonthlyFromSession)
		// attendanceGroup.GET("/today/generate", attendance.GenerateDaily)
	}

}

func addCompanyGroupEndpoints(baseGroup *gin.RouterGroup) {
	// user related endpoints
	companyGroup := baseGroup.Group("/companies")
	{

		companyGroup.GET("", company.GetAll)
		companyGroup.GET("/me", company.GetFromSession)
		companyGroup.GET("/:id", company.GetById)
	}

}

func addQrGroupEndpoints(baseGroup *gin.RouterGroup) {

	// user related endpoints
	qrGroup := baseGroup.Group("/qrs")
	{
		qrGroup.GET("", qr.GetAll)
		qrGroup.GET("/:id", qr.GetById)
		qrGroup.GET("/image/:id", qr.GetImageById)
	}

}

func addPrivateGroupEndpoints(baseGroup *gin.RouterGroup) {
	// Private group, require authentication to access
	private := baseGroup.Group("/private")
	private.Use(handlers.AuthRequired)
	{
		addAttendanceGroupEndpoints(private)
		addCompanyGroupEndpoints(private)
		addQrGroupEndpoints(private)
		addUserGroupEndpoints(private)
	}
}

func Setup() *gin.Engine {
	r := gin.New()

	// Setup the cookie store for session management
	r.Use(sessions.Sessions("mysession", sessions.NewCookieStore(data.Secret)))
	//logger
	r.Use(gin.Logger())
	// home
	r.Use(favicon.New("./assets/favicon.ico"))
	r.LoadHTMLGlob("templates/*.tmpl")
	r.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusFound, "/api/v1/")
	})

	// swagger
	docs.SwaggerInfo.BasePath = "/api/v1"
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))

	v1 := r.Group("/api/v1")
	{
		v1.StaticFile("/im1.jpg", "./assets/im1.jpg")
		v1.StaticFile("/im2.png", "./assets/noimage_person.png")
		v1.GET("/", handlers.GetHome)
		v1.GET("/index", handlers.GetHome)
		v1.GET("/home", handlers.GetHome)
		// Login and logout routes
		v1.POST("/login", user.Login)
		v1.GET("/logout", user.Logout)
		v1.GET("/image/:id", user.GetPictureById)

		v1.GET("/reset/attendance/today", attendance.DeleteDaily)
		v1.GET("/reset/attendance/all", attendance.DeleteAll)

		addPrivateGroupEndpoints(v1)

	}
	return r
}
