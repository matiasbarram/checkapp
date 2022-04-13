package controllers

import (
	"checkapp_api/models"
	"crypto/md5"
	"encoding/hex"
	"errors"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

const userQuery = "SELECT id, company_id, name, rut, role, email, password, IFNULL(device_id, -1) FROM user"

func GetUserById(id int64) (models.User, error) {

	var user models.User
	db, err := models.GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return user, nil
	}

	defer db.Close()
	row := db.QueryRow(userQuery+" WHERE id = ?", id)
	err = row.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Email, &user.Password, &user.Device_id)
	if err != nil {
		fmt.Println("Err", err.Error())
		return user, err
	}
	return user, err

}

func GetMD5Hash(text string) string {
	hash := md5.Sum([]byte(text))
	return hex.EncodeToString(hash[:])
}

func ValidateCredentials(u models.UserCredentials) (models.User, error) {

	var user models.User
	db, err := models.GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return user, nil
	}

	defer db.Close()
	row := db.QueryRow(userQuery+" WHERE email = ?", u.Email)
	err = row.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Email, &user.Password, &user.Device_id)

	if err != nil {
		fmt.Println("Err", err.Error())
		return user, err
	}

	if GetMD5Hash(u.Password) != user.Password {
		return models.User{}, errors.New("LAPASS")
	}
	return user, err

}

func GetUsers() []models.User {

	db, err := models.GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil
	}

	defer db.Close()
	results, err := db.Query(userQuery)

	if err != nil {
		fmt.Println("Err", err.Error())
		return nil
	}

	users := []models.User{}
	for results.Next() {
		var user models.User
		// for each row, scan into the models.Users struct
		err = results.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Email, &user.Password, &user.Device_id)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		users = append(users, user)
	}

	return users

}

func PostUser(user models.User) (models.User, error) {

	db, err := models.GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return user, nil
	}

	defer db.Close()
	res, err := db.Exec("INSERT INTO user (company_id, name, rut, role, email, password) VALUES (?, ?, ?, ?, ?, MD5(?))",
		user.Company_id, user.Name, user.Rut, user.Role, user.Email, user.Password)
	if err != nil {
		fmt.Println("Err", err.Error())
		return user, err
	}
	id, err := res.LastInsertId()
	user.Id = int(id)
	return user, err

}
