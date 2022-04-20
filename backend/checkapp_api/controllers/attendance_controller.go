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
    u.company_id,
    u.name,
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

const lastEventFromUserQuery = `
SELECT * FROM attendance WHERE id=(SELECT MAX(id) FROM attendance WHERE user_id = ?);
`
const insertAttendanceQuery = `
INSERT INTO attendance (user_id, location, event_type, confirmed, comments) VALUES (?, ?, ?, ?, ?)
`

func RegisterAttendance(user_info models.AttendanceParams, userId int64) (models.Attendance, error) {

	var attendance models.Attendance
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return attendance, err
	}

	defer db.Close()
	// consultar por la info del usuario a registrar
	row := db.QueryRow(attendance_query, userId)
	var real_user_info models.UserAttendanceInfo
	err = row.Scan(
		&real_user_info.Id,
		&real_user_info.Company_id,
		&real_user_info.Name,
		&real_user_info.Company,
		&real_user_info.Company_location,
		&real_user_info.Device_secret_key)
	if err != nil {
		fmt.Println("Err", err.Error()+" scan")
		return attendance, err
	}
	// verificar que la info proporcionada por el usuario coincida con la
	// de la base de datos (company_id, device_secret_key)
	err = checkAttendanceParams(user_info, real_user_info)
	if err != nil {
		return attendance, err
	}

	err = utils.ValidateUserLocation(user_info.Location, real_user_info.Company_location)
	if err != nil {
		return attendance, err
	}
	return postAttendance(user_info, userId)
}

// func getLastEvent(userId int) (models.Attendance, error) {
// 	var attendance models.Attendance
// 	db, err := GetDB()

// 	// if there is an error opening the connection, handle it
// 	if err != nil {
// 		// simply print the error to the console
// 		fmt.Println("Err", err.Error())
// 		// returns nil on error
// 		return attendance, nil
// 	}

// 	defer db.Close()
// 	row := db.QueryRow("SELECT * FROM attendance WHERE id = ?", userId)
// 	err = row.Scan(
// 		&attendance.Id,
// 		&attendance.User_id,
// 		&attendance.Event_type,
// 		&attendance.Event_time,
// 		&attendance.Location,
// 		&attendance.Confirmed,
// 		&attendance.Comments)
// 	if err != nil {
// 		fmt.Println("Err", err.Error())
// 	}
// 	return attendance, err
// }

func checkEventType(userId int64, eventType string) (string, bool) {
	lastAttendance, err := GetLastEventFromUser(userId)
	// no presenta registros?
	if err != nil {
		fmt.Println("Error! " + err.Error())
		return "CHECK_IN", false
	}
	nextEvent := data.NextAttendanceEvent[lastAttendance.Event_type]
	if eventType == "NEXT" || eventType == "AUTO" {
		return nextEvent, false
	}
	if nextEvent != eventType {
		return eventType, true
	}
	return eventType, false
}

func postAttendance(attendance_params models.AttendanceParams, userId int64) (models.Attendance, error) {
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
	eventType, needsConfirmation := checkEventType(userId, attendance_params.Event_type)
	res, err := db.Exec(insertAttendanceQuery,
		userId,
		attendance_params.Location,
		eventType,
		!needsConfirmation,
		attendance_params.Comments)
	if err != nil {
		fmt.Println("Err", err.Error())
		return attendance, err
	}
	id, err := res.LastInsertId()
	return GetAttendanceById(id)
}

func checkAttendanceParams(attendance_params models.AttendanceParams,
	real_user_info models.UserAttendanceInfo) error {
	if attendance_params.Company_id != real_user_info.Company_id {
		return errors.New("you dont belong to this company 💢")
	}

	// if attendance_params.Device_secret_key != real_user_info.Device_secret_key {
	// 	return errors.New("this is not your phone 💢")
	// }
	if !utils.StringInSlice(attendance_params.Event_type, data.AttendaceEventTypes[:]) {
		return errors.New(
			fmt.Sprint("invalid value for event_type: \""+attendance_params.Event_type+"\".\n",
				"Valid options: ", data.AttendaceEventTypes))
	}
	return nil
}

func GetLastEventFromUser(id int64) (models.Attendance, error) {

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
	row := db.QueryRow(lastEventFromUserQuery, id)
	err = row.Scan(
		&attendance.Id,
		&attendance.User_id,
		&attendance.Event_type,
		&attendance.Event_time,
		&attendance.Location,
		&attendance.Confirmed,
		&attendance.Comments)
	if err != nil {
		fmt.Println("Err", err.Error())
	}
	return attendance, err
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
	err = row.Scan(
		&attendance.Id,
		&attendance.User_id,
		&attendance.Event_type,
		&attendance.Event_time,
		&attendance.Location,
		&attendance.Confirmed,
		&attendance.Comments)
	if err != nil {
		fmt.Println("Err", err.Error())
	}
	return attendance, err
}

func GetAttendanceFromUser(id int64) ([]models.Attendance, error) {

	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil, nil
	}

	defer db.Close()

	results, err := db.Query("SELECT * FROM attendance WHERE user_id = ?", id)
	attendances := []models.Attendance{}
	for results.Next() {
		var attendance models.Attendance
		// for each row, scan into the models.attendances struct
		err = results.Scan(
			&attendance.Id,
			&attendance.User_id,
			&attendance.Event_type,
			&attendance.Event_time,
			&attendance.Location,
			&attendance.Confirmed,
			&attendance.Comments)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		attendances = append(attendances, attendance)
	}

	return attendances, nil
}
