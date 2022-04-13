package controllers

import (
	"checkapp_api/models"
	"encoding/json"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
	qrcode "github.com/skip2/go-qrcode"
)

func GetQrById(id int64) (models.Qr, error) {

	var qr models.Qr
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return qr, nil
	}
	defer db.Close()
	row := db.QueryRow("SELECT * FROM qr WHERE id = ?", id)
	err = row.Scan(&qr.Id, &qr.Company_id, &qr.Content)

	if err != nil {
		fmt.Println("Err", err.Error())
		return qr, err
	}
	return qr, err

}

func GetQrImageById(id int64) ([]byte, error) {

	var png []byte
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return png, nil
	}
	defer db.Close()
	row := db.QueryRow("SELECT content FROM qr WHERE id = ?", id)
	err = row.Scan(&png)

	if err != nil {
		fmt.Println("Err", err.Error())
		return png, err
	}
	return png, err

}

func GetQrs() []models.Qr {

	// db, err := sql.Open("mysql", dbqr+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil
	}

	defer db.Close()
	results, err := db.Query("SELECT * FROM qr")

	if err != nil {
		fmt.Println("Err", err.Error())
		return nil
	}

	qrs := []models.Qr{}
	for results.Next() {
		var qr models.Qr
		// for each row, scan into the Qrs struct
		err = results.Scan(&qr.Id, &qr.Company_id, &qr.Content)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the qrsg into qr array
		qrs = append(qrs, qr)
	}

	return qrs

}

func GenerateQr(company_id int64) (models.Qr, error) {

	var qr models.Qr
	var company models.Company
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return qr, nil
	}

	defer db.Close()
	row := db.QueryRow("SELECT * FROM company WHERE id = ?", company_id)
	err = row.Scan(&company.Id, &company.Name, &company.Location)
	company_info, err := json.Marshal(company)
	company_string := string(company_info)
	png, err := qrcode.Encode(company_string, qrcode.Medium, 256)
	if err != nil {
		fmt.Println("Err", err.Error())
		return qr, err
	}
	res, err := db.Exec("INSERT INTO qr (company_id, content) VALUES (?, ?)", company_id, png)
	if err != nil {
		fmt.Println("Err", err.Error())
		return qr, err
	}
	// res, err := db.Query("SELECT LAST_INSERT_ID")_
	id, err := res.LastInsertId()
	fmt.Println(res)
	fmt.Println("id", id)
	qr = models.Qr{int(id), int(company_id), png}
	return qr, err

}
