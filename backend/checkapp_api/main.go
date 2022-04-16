package main

import (
	"checkapp_api/data"
	"checkapp_api/router"
	"fmt"
	"log"
)

// @title           CheckApp Server API
// @description     This is a server for gente xora
// @termsOfService  http://swagger.io/terms/

// @contact.name   API Support
// @contact.url    http://www.swagger.io/support
// @contact.email  support@swagger.io

// @license.name  Apache 2.0
// @license.url   http://www.apache.org/licenses/LICENSE-2.0.html

// @host      api.asiendosoftware.xyz
// @securityDefinitions.basic BasicAuth
// @BasePath  /api/v1
// @schemes   http https
func main() {
	run("")
}

func run(configPath string) {
	// if configPath == "" {
	// 	configPath = "data/config.dev.yml"
	// }
	// setConfiguration(configPath)
	// conf := config.GetConfig()
	web := router.Setup()
	fmt.Println("Go API REST Running on port " + data.Port)
	fmt.Println("==================>")
	if err := web.Run(data.Port); err != nil {
		log.Fatal("Unable to start:", err)
	}
}
