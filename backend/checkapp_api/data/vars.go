package data

import (
	"fmt"
	"os"

	"github.com/go-playground/validator/v10"
	"github.com/joho/godotenv"
)

//database related
var ConnectionString string

// firebase
var FIREBASE_JSON string

//// cookies - session
var Secret = []byte("secret")

// attendance
var AttendanceEventTypes = [4]string{"CHECK_IN", "CHECK_OUT", "NEXT", "AUTO"}
var CHECK_OUT = "CHECK_OUT"
var CHECK_IN = "CHECK_IN"
var PENDING = "PENDING"
var ON_TIME = "ON_TIME"
var LATE_ARRIVAL = "LATE_ARRIVAL"
var EARLY_LEAVE = "EARLY_LEAVE"
var NO_TIME_DIFF = "00:00:00"
var DATE_FORMAT = "2006-01-02"

var ADMIN_ROLE = "based"

var NextAttendanceEvent = map[string]string{
	"CHECK_IN":  "CHECK_OUT",
	"CHECK_OUT": "CHECK_IN",
}

var EventIsArrival = map[string]bool{
	"CHECK_IN":  true,
	"CHECK_OUT": false,
}

var DaysOfTheWeek = map[int]string{
	1: "Sunday",
	2: "Monday",
	3: "Tuesday",
	4: "Wednesday",
	5: "Thursday",
	6: "Friday",
	7: "Saturday",
}

// TODO: ver si se usa
var Validate *validator.Validate

func LoadEnv() {
	_ = godotenv.Load("../.env") // Cargar del archivo llamado ".env"

	ConnectionString = fmt.Sprintf("%s:%s@tcp(%s:%s)/%s",
		os.Getenv("user"),
		os.Getenv("pass"),
		os.Getenv("host"),
		os.Getenv("port"),
		os.Getenv("db_name"))

	FIREBASE_JSON = os.Getenv("firebase_json")
}
