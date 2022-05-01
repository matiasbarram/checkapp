package controllers

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/go-sql-driver/mysql"

	"github.com/joho/godotenv"
)

var _ = godotenv.Load(".env") // Cargar del archivo llamado ".env"
var (
	ConnectionString = fmt.Sprintf("%s:%s@tcp(%s:%s)/%s",
		os.Getenv("user"),
		os.Getenv("pass"),
		os.Getenv("host"),
		os.Getenv("port"),
		os.Getenv("db_name"))
)

var db *sql.DB

// InitDB sets up setting up the connection pool global variable.
func InitDB() error {
	var err error

	db, err = sql.Open("mysql", ConnectionString)
	if err != nil {
		return err
	}

	return db.Ping()
}

func GetDB() (*sql.DB, error) {
	return sql.Open("mysql", ConnectionString)
}
