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

const userQueryId = userQuery + "WHERE id = ?"
const userQueryEmail = userQuery + "WHERE email = ?"

const userPictureQuery = "SELECT picture FROM user WHERE id = ?"

const notificationRecipientsQuery = `
SELECT
	users.id,
    users.name,
    users.email,
    c.name AS company
FROM
    user users
JOIN user u ON
    u.id = ?
INNER JOIN company c ON
    c.id = u.company_id
WHERE
    users.company_id = c.id AND users.role = 'based' OR users.id = u.id
`

var putUserImageQuery = `
UPDATE user
SET picture = ?
WHERE id = ?; 
`

func GetUserById(id int64) (models.User, error) {

	var user models.User
	row := db.QueryRow(userQueryId, id)
	err := row.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Email, &user.Password, &user.Device_id)
	if err != nil {
		fmt.Println("Err", err.Error())
		return user, err
	}
	return user, err

}

func GetUserPicture(id int64) ([]byte, error) {

	var imgBytes = []byte{}
	err := db.QueryRow(userPictureQuery, id).Scan(&imgBytes)
	return imgBytes, err
}

func GetMD5Hash(text string) string {
	hash := md5.Sum([]byte(text))
	return hex.EncodeToString(hash[:])
}

func ValidateCredentials(u models.UserCredentials) (models.User, error) {

	var user models.User

	row := db.QueryRow(userQueryEmail, u.Email)
	err := row.Scan(&user.Id, &user.Company_id, &user.Name, &user.Rut, &user.Role, &user.Email, &user.Password, &user.Device_id)

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

func PutUserPicture(id int64, picture []byte) (models.User, error) {
	var user models.User
	_, err := db.Exec(putUserImageQuery, picture, id)
	if err != nil {
		return user, err
	}
	return GetUserById(id)
}

func GetNotificationRecipients(userId int64) (models.NotificationRecipient, []models.NotificationRecipient, error) {
	results, err := db.Query(notificationRecipientsQuery, userId)
	var user models.NotificationRecipient
	var recipients []models.NotificationRecipient
	if err != nil {
		fmt.Println("Err", err.Error())
		return user, recipients, err
	}
	for results.Next() {
		var recipient models.NotificationRecipient
		err = results.Scan(
			&recipient.Id,
			&recipient.Name,
			&recipient.Email,
			&recipient.Company,
		)
		if err != nil {
			panic(err.Error())
		}
		recipients = append(recipients, recipient)
	}
	user = recipients[0]
	recipients = recipients[1:]
	return user, recipients, nil
}
