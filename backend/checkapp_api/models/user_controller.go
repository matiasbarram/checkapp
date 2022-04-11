package models

import (
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

// const dbuser = "root"
// const dbpass = "root"
// const dbname = "checkapp"

func GetUserById(id int64) (User, error) {

	var user User
	// db, err := sql.Open("mysql", dbuser+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := getDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return user, nil
	}

	defer db.Close()
	row := db.QueryRow("SELECT * FROM user WHERE id = ?", id)
	err = row.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Device_id)

	if err != nil {
		fmt.Println("Err", err.Error())
		return user, err
	}
	return user, err

}

func GetUsers() []User {

	// db, err := sql.Open("mysql", dbuser+":"+dbpass+"@tcp(127.0.0.1:3306)/"+dbname)
	db, err := getDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil
	}

	defer db.Close()
	results, err := db.Query("SELECT * FROM user")

	if err != nil {
		fmt.Println("Err", err.Error())
		return nil
	}

	users := []User{}
	for results.Next() {
		var user User
		// for each row, scan into the Users struct
		err = results.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Device_id)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		users = append(users, user)
	}

	return users

}
