package main

import (
	"checkapp_api/data"
	"checkapp_api/router"
	"fmt"
	"log"
)

// use a single instance of Validate, it caches struct info
// var validate *validator.Validate

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

// func validateId(id_str string, c *gin.Context) int64 {
// 	id, err := strconv.ParseInt(id_str, 10, 64)
// 	if err != nil {
// 		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "invalid value for id: " + id_str})
// 	}
// 	return id
// }

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
