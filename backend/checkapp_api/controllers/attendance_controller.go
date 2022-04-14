package controllers

import (
	"checkapp_api/data"
	"checkapp_api/models"
	"checkapp_api/utils"
	"errors"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

const attendance_query = `
SELECT
    u.id,
    u.name,
    u.company_id,
    c.name AS company,
    c.location as company_location,
    d.secret_key as device_secret_key
FROM
    user u
INNER JOIN company c ON
    u.company_id = c.id
INNER JOIN device d ON
    u.device_id = d.id
WHERE
    u.id = ?
`

func RegisterAttendance(user_info models.AttendanceParams) (models.Attendance, error) {

	var attendance models.Attendance
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return attendance, nil
	}

	defer db.Close()
	// consultar por la info del usuario a registrar
	row := db.QueryRow(attendance_query, user_info.User_id)
	var real_user_info models.UserAttendanceInfo
	err = row.Scan(&real_user_info.Id,
		&real_user_info.Name,
		&real_user_info.Company_id,
		&real_user_info.Company,
		&real_user_info.Company_location,
		&real_user_info.Device_secret_key)
	if err != nil {
		fmt.Println("Err", err.Error())
		return attendance, err
	}
	// verificar que la info proporcionada por el usuario coincida con la
	// de la base de datos (company_id, device_secret_key)
	err = compareUserInfo(user_info, real_user_info)
	if err != nil {
		return attendance, err
	}

	distance, err := utils.CalculateDistance(user_info.Location, real_user_info.Company_location)
	if err != nil {
		return attendance, err
	}

	if distance > data.AttendanceDistanceLimit {
		return attendance, errors.New("you are too far away from your company 💢 (distance : " + fmt.Sprint(distance) + " )")
	}

	return attendance, err
}

func postAttendance(attendance_params models.AttendanceParams) (models.Attendance, error) {
	var attendance models.Attendance
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return attendance, nil
	}
	defer db.Close()
	res, err := db.Exec("INSERT INTO Attendance (user_id, location, event_type) VALUES (?, ?, ?)",
		attendance_params.User_id, attendance_params.Location, attendance_params.Event_type)
	if err != nil {
		fmt.Println("Err", err.Error())
		return attendance, err
	}
	id, err := res.LastInsertId()
	return GetAttendanceById(id)
}

func compareUserInfo(attendance_params models.AttendanceParams,
	real_user_info models.UserAttendanceInfo) error {
	if utils.StringInSlice(attendance_params.Event_type, data.AttendaceEventTypes[:]) {
		return errors.New(
			fmt.Sprint("invalid value for event_type: "+attendance_params.Event_type+" .\n",
				"Valid options: ", data.AttendaceEventTypes))
	}
	if attendance_params.Company_id != real_user_info.Company_id {
		return errors.New("you dont belong to this company 💢")
	}

	if attendance_params.Device_secret_key != real_user_info.Device_secret_key {
		return errors.New("this is not your phone 💢")
	}
	return nil
}

func GetAttendanceById(id int64) (models.Attendance, error) {

	var attendance models.Attendance
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return attendance, nil
	}

	defer db.Close()
	row := db.QueryRow("SELECT * FROM attendance WHERE id = ?", id)
	err = row.Scan(&attendance.Id,
		&attendance.User_id,
		&attendance.Event_type,
		&attendance.Event_time,
		&attendance.Location)
	if err != nil {
		fmt.Println("Err", err.Error())
	}
	return attendance, err
}
