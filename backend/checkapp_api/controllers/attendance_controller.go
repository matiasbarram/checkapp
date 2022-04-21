package controllers

import (
	"checkapp_api/data"
	"checkapp_api/models"
	"checkapp_api/utils"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

const attendance_query = `
SELECT
    u.id,
    u.company_id,
    u.name,
    c.name AS company,
    c.location as company_location,
    d.secret_key as device_secret_key,
    s.check_in_time,
	s.check_out_time
FROM
    user u
INNER JOIN company c ON
    u.company_id = c.id
INNER JOIN device d ON
    u.device_id = d.id
INNER JOIN shift s ON
    u.shift_id = s.id
WHERE
    u.id = ?
`

const lastEventFromUserQuery = `
SELECT * FROM attendance WHERE id=(SELECT MAX(id) FROM attendance WHERE user_id = ?);
`
const insertAttendanceQuery = `
INSERT INTO attendance (user_id, location, event_type, confirmed, comments, expected_time) VALUES (?, ?, ?, ?, ?, ?)
`
const lastTwoEventsFromUserQuery = `
SELECT * FROM attendance WHERE user_id = ? ORDER BY id DESC LIMIT 2; 
`
const getUserShiftQuery = `
SELECT * FROM shift WHERE id=(SELECT shift_id FROM user WHERE id = ?); 
`
const getTodaysEventsQuery = `
SELECT
    event_type,
	expected_time,
	event_time,
	confirmed
FROM
    attendance
WHERE
    user_id = ? AND DATE(event_time) = CURRENT_DATE
ORDER BY
    id
DESC
LIMIT 2;
`

func RegisterAttendance(user_info models.AttendanceParams, userId int64) (models.Attendance, error) {

	var attendance models.Attendance
	err := canRegisterAttendance(userId, user_info)
	if err != nil {
		return attendance, err
	}

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
	var shift models.Shift
	err = row.Scan(
		&real_user_info.Id,
		&real_user_info.Company_id,
		&real_user_info.Name,
		&real_user_info.Company,
		&real_user_info.Company_location,
		&real_user_info.Device_secret_key,
		&shift.CheckInTime,
		&shift.CheckOutTime)
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
	return postAttendance(user_info, userId, shift)
}

func canRegisterAttendance(userId int64, user_info models.AttendanceParams) error {
	attendance, err := GetLastEventFromUser(userId)
	if err != nil && err != sql.ErrNoRows {
		return err
	}
	if err != nil && err == sql.ErrNoRows {
		return nil
	}
	t, _ := time.Parse(time.RFC3339, strings.Replace(attendance.Event_time, " ", "T", 1)+"-04:00")
	now := time.Now()
	diff := now.Sub(t)
	if attendance.Event_type == data.AttendanceEventTypes[1] && diff.Hours() < 8 {
		return errors.New("han pasado menos de ocho horas de tu ultima salida xd, anda a dormir")
	}
	if user_info.Event_type == attendance.Event_type {
		return errors.New("Necesitas marcar " + data.NextAttendanceEvent[attendance.Event_type] + " antes de continuar")
	}
	return nil
}

func getMonthlyAttendance() {

}

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

func postAttendance(attendance_params models.AttendanceParams, userId int64, shift models.Shift) (models.Attendance, error) {
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
	eventType, eventNeedsConfirmation := checkEventType(userId, attendance_params.Event_type)
	expectedTime, timeNeedsConfirmation, comments := getEventExpectedTime(eventType, shift)
	res, err := db.Exec(insertAttendanceQuery,
		userId,
		attendance_params.Location,
		eventType,
		!(eventNeedsConfirmation || timeNeedsConfirmation),
		comments,
		expectedTime)
	if err != nil {
		fmt.Println("Err", err.Error())
		return attendance, err
	}
	id, err := res.LastInsertId()
	return GetAttendanceById(id)
}

func getEventExpectedTime(eventType string, shift models.Shift) (string, bool, string) {
	var expectedTime string
	var comments string
	now := time.Now()
	year, month, day := now.Date()
	todayString := fmt.Sprintf("%d-%02d-%02dT", year, month, day)
	if eventType == data.AttendanceEventTypes[0] { //check_in
		expectedTime = shift.CheckInTime
		comments = "oe sangano kl estas son oras de llegar? atraso de "
	} else {
		expectedTime = shift.CheckOutTime
		comments = "muy temprano pa irse mi rey, teni k esperar "
	}
	// expectedTimeObject, _ := time.Parse("14:23:10", expectedTime)
	// expectedTimeObject2, _ := time.Parse("14:23:10", "09:00:00")
	// fmt.Println(expectedTimeObject)
	// fmt.Println(expectedTimeObject2)
	// t, _ := time.Parse(time.RFC3339, "2006-01-02T15:04:05Z")
	// fmt.Println(t)
	expectedTimeObject, _ := time.Parse(time.RFC3339, todayString+expectedTime+"-04:00")
	fmt.Println(expectedTimeObject)
	var diff time.Duration
	if eventType == data.AttendanceEventTypes[0] {
		diff = now.Sub(expectedTimeObject)
	} else {
		diff = expectedTimeObject.Sub(now)
	}
	fmt.Println(diff)
	var needsConfirmation bool
	if diff.Minutes() > data.AttendanceTimeOffsetLimit {
		needsConfirmation = true
		comments = comments + fmt.Sprintf("%f", diff.Minutes()) + " minutos"
	} else {
		comments = ""
		needsConfirmation = false
	}
	return expectedTime, needsConfirmation, comments
}

func checkAttendanceParams(attendance_params models.AttendanceParams,
	real_user_info models.UserAttendanceInfo) error {
	fmt.Println(attendance_params)
	if attendance_params.Company_id != real_user_info.Company_id {
		return errors.New("you dont belong to this company 💢")
	}

	// if attendance_params.Device_secret_key != real_user_info.Device_secret_key {
	// 	return errors.New("this is not your phone 💢")
	// }
	if !utils.StringInSlice(attendance_params.Event_type, data.AttendanceEventTypes[:]) {
		return errors.New(
			fmt.Sprint("invalid value for event_type: \""+attendance_params.Event_type+"\".\n",
				"Valid options: ", data.AttendanceEventTypes))
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
		&attendance.Comments,
		&attendance.Expected_time)
	if err != nil {
		fmt.Println("Err", err.Error())
	}
	return attendance, err
}

func GetTodaysAttendance(id int64) ([]models.SimpleAttendance, error) {

	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil, nil
	}

	defer db.Close()

	attendances := []models.SimpleAttendance{}
	results, err := db.Query(getTodaysEventsQuery, id)
	if err != nil {
		return attendances, err
	}
	for results.Next() {
		var attendance models.SimpleAttendance
		attendance.Pending = false
		// for each row, scan into the models.attendances struct
		err = results.Scan(
			&attendance.EventType,
			&attendance.ExpectedTime,
			&attendance.EventTime,
			&attendance.Confirmed)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		attendances = append(attendances, attendance)
	}
	if len(attendances) == 2 {
		return attendances, nil
	}
	return generateMissingAttendances(id, attendances)
}

func generateMissingAttendances(id int64, attendances []models.SimpleAttendance) ([]models.SimpleAttendance, error) {

	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil, nil
	}

	defer db.Close()

	var shift models.Shift
	row := db.QueryRow(getUserShiftQuery, id)
	err = row.Scan(
		&shift.Id,
		&shift.CheckInTime,
		&shift.CheckOutTime,
		&shift.LunchBreakLength)
	if err != nil {
		fmt.Println("Err", err.Error())
	}
	if len(attendances) == 0 {
		var attendance models.SimpleAttendance
		attendance.EventType = data.AttendanceEventTypes[0]
		attendance.ExpectedTime = shift.CheckInTime
		attendance.Pending = true
		attendances = append(attendances, attendance)
	}
	if len(attendances) == 1 {
		var attendance models.SimpleAttendance
		attendance.EventType = data.AttendanceEventTypes[1]
		attendance.ExpectedTime = shift.CheckOutTime
		attendance.Pending = true
		attendances = append(attendances, attendance)
	}
	return attendances, nil
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
		&attendance.Comments,
		&attendance.Expected_time)
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
			&attendance.Comments,
			&attendance.Expected_time)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		attendances = append(attendances, attendance)
	}

	return attendances, nil
}
