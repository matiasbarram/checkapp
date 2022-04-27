package controllers

import (
	"fmt"

	"checkapp_api/models"

	_ "github.com/go-sql-driver/mysql"
)

const companyByUserIdQuery = `
SELECT
    *
FROM
    company
WHERE
    id =(
    SELECT
        u.company_id
    FROM
        user u
    WHERE
        u.id = ?
);`

func GetCompanyById(id int64) (models.Company, error) {

	var company models.Company
	// db, err := sql.Open("mysql", dbcompany+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := GetDB()

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

func GetCompanies() []models.Company {

	// db, err := sql.Open("mysql", dbcompany+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := GetDB()

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

	companies := []models.Company{}
	for results.Next() {
		var company models.Company
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

func GetCompanyByUserId(userId int64) (models.Company, error) {

	var company models.Company
	db, err := GetDB()
	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return company, err
	}

	defer db.Close()
	row := db.QueryRow(companyByUserIdQuery, userId)
	err = row.Scan(&company.Id, &company.Name, &company.Location)

	if err != nil {
		fmt.Println("Err", err.Error())
		return company, err
	}
	return company, err

}
