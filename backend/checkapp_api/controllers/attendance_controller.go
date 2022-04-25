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

	ic "github.com/WAY29/icecream-go/icecream"
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
	event_time
FROM
    attendance
WHERE
    user_id = ? AND DATE(event_time) = CURRENT_DATE
ORDER BY
    id
DESC
LIMIT 2;
`

const deleteTodaysAttendance = `
DELETE FROM attendance WHERE DATE(event_time) = CURRENT_DATE;
`
const deleteAllAttendance = `
DELETE FROM attendance;
`

func RegisterAttendance(user_info models.AttendanceParams, userId int64) (models.AttendanceResponse, error) {

	var attendanceResponse models.AttendanceResponse
	err := canRegisterAttendance(userId, user_info)
	if err != nil {
		return attendanceResponse, err
	}

	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return attendanceResponse, err
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
		ic.Ic(err.Error())
		return attendanceResponse, err
	}
	// verificar que la info proporcionada por el usuario coincida con la
	// de la base de datos (company_id, device_secret_key)
	err = checkAttendanceParams(user_info, real_user_info)
	if err != nil {
		return attendanceResponse, err
	}

	err = utils.ValidateUserLocation(user_info.Location, real_user_info.Company_location)
	if err != nil {
		return attendanceResponse, err
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
	t, _ := time.Parse(time.RFC3339, strings.Replace(attendance.EventTime, " ", "T", 1)+"-04:00")
	now := time.Now()
	diff := now.Sub(t)
	if attendance.EventType == data.AttendanceEventTypes[1] && diff.Hours() < 8 {
		return errors.New(fmt.Sprint(1))
	}
	if user_info.Event_type == attendance.EventType {
		var nxt int
		if data.NextAttendanceEvent[attendance.EventType] == data.AttendanceEventTypes[0] {
			nxt = 2
		} else {
			nxt = 3
		}
		return errors.New(fmt.Sprint(nxt))
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
	nextEvent := data.NextAttendanceEvent[lastAttendance.EventType]
	if eventType == "NEXT" || eventType == "AUTO" {
		return nextEvent, false
	}
	if nextEvent != eventType {
		return eventType, true
	}
	return eventType, false
}

func postAttendance(attendance_params models.AttendanceParams, userId int64, shift models.Shift) (models.AttendanceResponse, error) {
	// var attendance models.Attendance
	var attendanceResponse models.AttendanceResponse
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return attendanceResponse, nil
	}
	defer db.Close()
	eventType, _ := checkEventType(userId, attendance_params.Event_type)
	expectedTime := getEventExpectedTime(eventType, shift)
	// timeDiff, result, err := utils.GetFormattedTimeDiff(attendance.EventTime,
	// 	attendance.ExpectedTime,
	// 	data.EventIsArrival[attendance.EventType])
	// comments := fmt.Sprintf("%s,%s", timeDiff, result)
	// ic.Ic(comments)
	res, err := db.Exec(insertAttendanceQuery,
		userId,
		attendance_params.Location,
		eventType,
		true,
		"",
		expectedTime)
	if err != nil {
		fmt.Println("Err", err.Error())
		return attendanceResponse, err
	}
	id, err := res.LastInsertId()
	return getAttendanceResponseById(id)
}

func getAttendanceResponseById(id int64) (models.AttendanceResponse, error) {
	var attendanceResponse models.AttendanceResponse
	attendance, err := GetAttendanceById(id)
	if err != nil {
		return attendanceResponse, err
	}
	timeDiff, comments, err := utils.GetFormattedTimeDiff(attendance.EventTime,
		attendance.ExpectedTime,
		data.EventIsArrival[attendance.EventType])
	attendanceResponse.Comments = comments
	attendanceResponse.TimeDiff = timeDiff
	attendanceResponse.EventTime = attendance.EventTime
	attendanceResponse.EventType = attendance.EventType
	attendanceResponse.ExpectedTime = attendance.ExpectedTime
	attendanceResponse.Pending = false
	return attendanceResponse, nil
}

func ResetTodayAttendance() error {
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil
	}
	res, err := db.Exec(deleteTodaysAttendance)
	fmt.Println(res)
	return err
}

func ResetAllAttendance() error {
	db, err := GetDB()

	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return nil
	}
	res, err := db.Exec(deleteAllAttendance)
	fmt.Println(res)
	return err
}

func getEventExpectedTime(eventType string, shift models.Shift) string {
	var expectedTime string
	// var comments string
	// now := time.Now()
	// year, month, day := now.Date()
	// todayString := fmt.Sprintf("%d-%02d-%02dT", year, month, day)
	if eventType == data.AttendanceEventTypes[0] { //check_in
		expectedTime = shift.CheckInTime
		// comments = "oe sangano kl estas son oras de llegar? atraso de "
	} else {
		expectedTime = shift.CheckOutTime
		// comments = "muy temprano pa irse mi rey, teni k esperar "
	}
	// expectedTimeObject, _ := time.Parse("14:23:10", expectedTime)
	// expectedTimeObject2, _ := time.Parse("14:23:10", "09:00:00")
	// fmt.Println(expectedTimeObject)
	// fmt.Println(expectedTimeObject2)
	// t, _ := time.Parse(time.RFC3339, "2006-01-02T15:04:05Z")
	// fmt.Println(t)
	// expectedTimeObject, _ := time.Parse(time.RFC3339, todayString+expectedTime+"-04:00")
	// fmt.Println(expectedTimeObject)
	// var diff time.Duration
	// if eventType == data.AttendanceEventTypes[0] {
	// 	diff = now.Sub(expectedTimeObject)
	// } else {
	// 	diff = expectedTimeObject.Sub(now)
	// }
	// fmt.Println(diff)
	// var needsConfirmation bool
	// if diff.Minutes() > data.AttendanceTimeOffsetLimit {
	// 	needsConfirmation = true
	// 	comments = comments + fmt.Sprintf("%f", diff.Minutes()) + " minutos"
	// } else {
	// 	comments = ""
	// 	needsConfirmation = false
	// }
	return expectedTime
}

func checkAttendanceParams(attendance_params models.AttendanceParams,
	real_user_info models.UserAttendanceInfo) error {
	if attendance_params.Company_id != real_user_info.Company_id {
		return errors.New(fmt.Sprint(4))
	}

	// if attendance_params.Device_secret_key != real_user_info.Device_secret_key {
	// 	return errors.New(fmt.Sprint(5))
	// }
	if !utils.StringInSlice(attendance_params.Event_type, data.AttendanceEventTypes[:]) {
		return errors.New(fmt.Sprint(6))
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
		&attendance.UserId,
		&attendance.EventType,
		&attendance.EventTime,
		&attendance.Location,
		&attendance.Confirmed,
		&attendance.Comments,
		&attendance.ExpectedTime)
	if err != nil {
		fmt.Println("Err", err.Error())
	}
	return attendance, err
}

func queryDailyAttendance(id int64) ([]models.AttendanceResponse, error) {
	attendances := []models.AttendanceResponse{}
	db, err := GetDB()
	if err != nil {
		return attendances, err
	}
	defer db.Close()

	results, err := db.Query(getTodaysEventsQuery, id)
	if err != nil {
		return attendances, err
	}
	for results.Next() {
		var attendance models.AttendanceResponse
		attendance.Pending = false
		// for each row, scan into the models.attendances struct
		err = results.Scan(
			&attendance.EventType,
			&attendance.ExpectedTime,
			&attendance.EventTime)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		attendance, err = calcTimeDiff(attendance)
		if err != nil {
			return nil, err
		}
		attendances = append(attendances, attendance)
	}
	return attendances, nil
}

func calcTimeDiff(attendance models.AttendanceResponse) (models.AttendanceResponse, error) {
	var err error
	// timeDiff, onTime := utils.GetFormattedTimeDiff(attendance, isArrival)
	timeDiff, comments, err := utils.GetFormattedTimeDiff(attendance.EventTime,
		attendance.ExpectedTime,
		data.EventIsArrival[attendance.EventType])
	if err != nil {
		ic.Ic(err.Error())
		return attendance, err
	}
	// attendance.TimeDiff = utils.FormatSecondsToHHMMSS(seconds)
	attendance.TimeDiff = timeDiff
	attendance.Comments = comments
	ic.Ic(attendance)
	return attendance, nil
}

func GetTodaysAttendance(id int64) ([]models.AttendanceResponse, error) {

	attendances, err := queryDailyAttendance(id)
	if err != nil {
		return nil, err
	}
	if len(attendances) == 2 {
		return attendances, nil
	}
	return generateMissingAttendances(id, attendances)
}

func generateMissingAttendances(id int64, attendances []models.AttendanceResponse) ([]models.AttendanceResponse, error) {

	shift, err := queryUsersCurrentShift(id)
	if err != nil {
		return attendances, err
	}

	if len(attendances) == 0 {
		var attendance models.AttendanceResponse
		attendance.EventType = data.AttendanceEventTypes[0]
		attendance.ExpectedTime = shift.CheckInTime
		attendance.Pending = true
		attendances = append(attendances, attendance)
	}
	if len(attendances) == 1 {
		var attendance models.AttendanceResponse
		attendance.EventType = data.AttendanceEventTypes[1]
		attendance.ExpectedTime = shift.CheckOutTime
		attendance.Pending = true
		attendances = append(attendances, attendance)
	}
	return attendances, nil
}

func queryUsersCurrentShift(id int64) (models.Shift, error) {
	var shift models.Shift
	db, err := GetDB()
	// if there is an error opening the connection, handle it
	if err != nil {
		// simply print the error to the console
		fmt.Println("Err", err.Error())
		// returns nil on error
		return shift, nil
	}
	defer db.Close()
	row := db.QueryRow(getUserShiftQuery, id)
	err = row.Scan(
		&shift.Id,
		&shift.CheckInTime,
		&shift.CheckOutTime,
		&shift.LunchBreakLength)
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
	return shift, nil
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
		&attendance.UserId,
		&attendance.EventType,
		&attendance.EventTime,
		&attendance.Location,
		&attendance.Confirmed,
		&attendance.Comments,
		&attendance.ExpectedTime)
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
			&attendance.UserId,
			&attendance.EventType,
			&attendance.EventTime,
			&attendance.Location,
			&attendance.Confirmed,
			&attendance.Comments,
			&attendance.ExpectedTime)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		attendances = append(attendances, attendance)
	}

	return attendances, nil
}
