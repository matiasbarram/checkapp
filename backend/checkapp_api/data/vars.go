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

var AttendaceEventTypes = [2]string{"CHECK_IN", "CHECK_OUT"}

var Validate *validator.Validate

var Secret = []byte("secret")
