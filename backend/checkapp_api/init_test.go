package main

import (
	"checkapp_api/controllers"
	"checkapp_api/data"
	"checkapp_api/router"
	"log"

	"github.com/WAY29/icecream-go/icecream"
	"github.com/gin-gonic/gin"
)

var r *gin.Engine
var myCookie string
var ApiV1 = "/api/v1/"
var PrivateUrl = ApiV1 + "private/"
var OpenUrl = ApiV1 + "open/"

// var w *httptest.ResponseRecorder

func init() {
	data.LoadEnv()
	err := controllers.InitDB()
	if err != nil {
		log.Fatal(err)
	}
	r = router.Setup()
	icecream.ConfigureIncludeContext(true)
}
