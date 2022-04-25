package data

import (
	"fmt"
	"os"

	"github.com/go-playground/validator/v10"
	"github.com/joho/godotenv"
)

var _ = godotenv.Load("../.env") // Cargar del archivo llamado ".env"
var (
	ConnectionString = fmt.Sprintf("%s:%s@tcp(%s:%s)/%s",
		os.Getenv("user"),
		os.Getenv("pass"),
		os.Getenv("host"),
		os.Getenv("port"),
		os.Getenv("db_name"))
)

var AttendanceEventTypes = [4]string{"CHECK_IN", "CHECK_OUT", "NEXT", "AUTO"}

var Validate *validator.Validate

var Secret = []byte("secret")

var NextAttendanceEvent = map[string]string{
	"CHECK_IN":  "CHECK_OUT",
	"CHECK_OUT": "CHECK_IN",
}

var EventIsArrival = map[string]bool{
	"CHECK_IN":  true,
	"CHECK_OUT": false,
}
