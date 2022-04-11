package models

import (
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

const dbcompany = "root"
const dbpass = "root"
const dbname = "checkapp"

func GetCompanyById(id int64) (Company, error) {

	var company Company
	// db, err := sql.Open("mysql", dbcompany+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := getDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return company, nil
	}

	defer db.Close()
	row := db.QueryRow("SELECT * FROM company WHERE id = ?", id)
	err = row.Scan(&company.Id, &company.Name, &company.Location)

	if err != nil {
		fmt.Println("Err", err.Error())
		return company, err
	}
	return company, err

}

func GetCompanies() []Company {

	// db, err := sql.Open("mysql", dbcompany+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := getDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil
	}

	defer db.Close()
	results, err := db.Query("SELECT * FROM company")

	if err != nil {
		fmt.Println("Err", err.Error())
		return nil
	}

	companies := []Company{}
	for results.Next() {
		var company Company
		// for each row, scan into the companies struct
		err = results.Scan(&company.Id, &company.Name, &company.Location)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the companies into company array
		companies = append(companies, company)
	}

	return companies

}
