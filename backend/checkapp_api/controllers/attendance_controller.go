package controllers

// TODO: cambiar los scans malditos por una funcion

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

func registerAttendanceScan(row *sql.Row) (models.UserAttendanceInfo, models.Shift, error) {
	var real_user_info models.UserAttendanceInfo
	var shift models.Shift
	err := row.Scan(
		&real_user_info.Id,
		&real_user_info.Company_id,
		&real_user_info.Name,
		&real_user_info.Company,
		&real_user_info.Company_location,
		&real_user_info.Device_secret_key,
		&shift.CheckInTime,
		&shift.CheckOutTime)
	return real_user_info, shift, err
}

func NewRegisterAttendance(userAttendanceParams models.AttendanceParams, userId int64) (models.AttendanceResponse, error) {

	var attendanceResponse models.AttendanceResponse
	todayAttendances, err := GetTodaysAttendance(userId)
	if err != nil {
		ic.Ic(err.Error())
		return attendanceResponse, err
	}

	if userAttendanceParams.Event_type == data.CHECK_IN && !todayAttendances[0].Pending {
		return attendanceResponse, errors.New(fmt.Sprint(11))
	}
	if userAttendanceParams.Event_type == data.CHECK_OUT && todayAttendances[0].Pending {
		return attendanceResponse, errors.New(fmt.Sprint(3))
	}
	if userAttendanceParams.Event_type == data.CHECK_OUT && !todayAttendances[1].Pending {
		return attendanceResponse, errors.New(fmt.Sprint(12))
	}

	var targetId int
	if userAttendanceParams.Event_type == data.CHECK_IN {
		targetId = todayAttendances[0].AttendaceId
	} else {
		targetId = todayAttendances[1].AttendaceId
	}

	row := db.QueryRow(attendanceQuery, userId)
	registeredUserInfo, shift, err := registerAttendanceScan(row)
	if err != nil {
		ic.Ic(err.Error())
		return attendanceResponse, err
	}
	// verificar que la info proporcionada por el usuario coincida con la
	// de la base de datos (company_id, device_secret_key)
	err = checkAttendanceParams(userAttendanceParams, registeredUserInfo)
	if err != nil {
		return attendanceResponse, err
	}

	err = utils.ValidateUserLocation(userAttendanceParams.Location, registeredUserInfo.Company_location)
	if err != nil {
		return attendanceResponse, err
	}
	return postAttendance(userAttendanceParams, userId, int64(targetId), shift)
}

// func canRegisterAttendance(userId int64, user_info models.AttendanceParams) error {
// 	attendance, err := GetLastEventFromUser(userId)
// 	if err != nil && err != sql.ErrNoRows {
// 		return err
// 	}
// 	if err != nil && err == sql.ErrNoRows {
// 		return nil
// 	}
// 	t, _ := time.Parse(time.RFC3339, strings.Replace(attendance.EventTime, " ", "T", 1)+"-04:00")
// 	now := time.Now()
// 	diff := now.Sub(t)

// 	// tiempo minimo desde la salida hasta la siguiente entrada
// 	if attendance.EventType == data.CHECK_OUT && diff.Hours() < data.MinHoursTillNextEvent {
// 		return errors.New(fmt.Sprint(1))
// 	}
// 	// Si intenta registrar otra el mismo evento que el ultimo ingresado
// 	if user_info.Event_type == attendance.EventType {
// 		var nxt int
// 		if data.NextAttendanceEvent[attendance.EventType] == data.CHECK_IN {
// 			nxt = 2
// 		} else {
// 			nxt = 3
// 		}
// 		return errors.New(fmt.Sprint(nxt))
// 	}
// 	return nil
// }

// func getMonthlyAttendance() {

// }

// func checkEventType(userId int64, eventType string) (string, bool) {
// 	lastAttendance, err := GetLastEventFromUser(userId)
// 	// no presenta registros?
// 	if err != nil {
// 		if err != sql.ErrNoRows {
// 			ic.Ic("Error! " + err.Error())
// 		}
// 		return "CHECK_IN", false
// 	}
// 	nextEvent := data.NextAttendanceEvent[lastAttendance.EventType]
// 	if eventType == "NEXT" || eventType == "AUTO" {
// 		return nextEvent, false
// 	}
// 	if nextEvent != eventType {
// 		return eventType, true
// 	}
// 	return eventType, false
// }

func postAttendance(attendanceParams models.AttendanceParams, userId int64, targetId int64, shift models.Shift) (models.AttendanceResponse, error) {
	var attendanceResponse models.AttendanceResponse
	var eventTime string
	err := db.QueryRow("SELECT now();").Scan(&eventTime)
	if err != nil {
		ic.Ic(err)
		return attendanceResponse, err
	}
	expectedTime := getEventExpectedTime(attendanceParams.Event_type, shift)
	_, comments, _ := utils.GetFormattedTimeDiff(eventTime,
		expectedTime,
		data.EventIsArrival[attendanceParams.Event_type])
	_, err = db.Exec(updateQuery,
		eventTime,
		attendanceParams.Location,
		false,
		comments,
		targetId)
	if err != nil {
		ic.Ic(err.Error())
		return attendanceResponse, err
	}
	return getAttendanceResponseById(targetId)
}

func getAttendanceResponseById(id int64) (models.AttendanceResponse, error) {
	var attendanceResponse models.AttendanceResponse
	attendance, err := GetAttendanceById(id)
	if err != nil {
		ic.Ic(err.Error())
		return attendanceResponse, err
	}
	timeDiff, comments, err := utils.GetFormattedTimeDiff(attendance.EventTime,
		attendance.ExpectedTime,
		data.EventIsArrival[attendance.EventType])
	if err != nil {
		ic.Ic(err.Error())
		return attendanceResponse, err
	}
	attendanceResponse.Comments = comments
	attendanceResponse.TimeDiff = timeDiff
	attendanceResponse.EventTime = attendance.EventTime
	attendanceResponse.EventType = attendance.EventType
	attendanceResponse.ExpectedTime = attendance.ExpectedTime
	attendanceResponse.Pending = false
	return attendanceResponse, nil
}

func ResetTodayAttendance() error {
	_, err := db.Exec(deleteTodaysAttendance)
	// ic.Ic(res.RowsAffected())
	return err
}

func ResetAllAttendance() error {
	res, err := db.Exec(deleteAllAttendance)
	fmt.Println(res)
	return err
}

func getEventExpectedTime(eventType string, shift models.Shift) string {
	var expectedTime string
	if eventType == data.AttendanceEventTypes[0] { //check_in
		expectedTime = shift.CheckInTime
	} else {
		expectedTime = shift.CheckOutTime
	}
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

func scanAttendanceRow(row *sql.Row) (models.Attendance, error) {
	var attendance models.Attendance
	err := row.Scan(
		&attendance.Id,
		&attendance.UserId,
		&attendance.EventType,
		&attendance.EventTime,
		&attendance.Location,
		&attendance.Pending,
		&attendance.Comments,
		&attendance.ExpectedTime)
	return attendance, err
}

func GetLastEventFromUser(id int64) (models.Attendance, error) {

	row := db.QueryRow(lastEventFromUserQuery, id)
	attendance, err := scanAttendanceRow(row)
	if err != nil && err != sql.ErrNoRows {
		fmt.Println("Err", err.Error())
	}
	return attendance, err
}

func scanAttendanceRowList(results *sql.Rows) ([]models.Attendance, error) {
	attendances := []models.Attendance{}
	for results.Next() {
		var attendance models.Attendance
		// for each row, scan into the models.Users struct
		err := results.Scan(
			&attendance.Id,
			&attendance.UserId,
			&attendance.EventType,
			&attendance.EventTime,
			&attendance.Location,
			&attendance.Pending,
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
func scanAttendanceRowListMinimal(results *sql.Rows, attendances []models.Attendance) ([]models.Attendance, error) {
	for results.Next() {
		var attendance models.Attendance
		// for each row, scan into the models.Users struct
		err := results.Scan(
			&attendance.EventType,
			&attendance.ExpectedTime,
			&attendance.EventTime,
			&attendance.Pending,
			&attendance.Id)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		// append the usersg into user array
		attendances = append(attendances, attendance)
		// ic.Ic("appending ", attendance)
	}
	return attendances, nil
}

func GetLastTwoEventsFromUser(id int64) ([]models.AttendanceResponse, error) {

	attendances := []models.Attendance{}
	attendanceResponses := []models.AttendanceResponse{}
	results, err := db.Query(getLastTwoEventsQuery, id)
	if err != nil {
		ic.Ic(err)
		return attendanceResponses, err
	}
	attendances, err = scanAttendanceRowListMinimal(results, attendances)
	if err != nil {
		return attendanceResponses, err
	}
	attendanceResponses, err = attendancesToAttendanceResponses(attendances, attendanceResponses)
	return attendanceResponses, err
}

func attendancesToAttendanceResponses(attendances []models.Attendance,
	responses []models.AttendanceResponse) ([]models.AttendanceResponse, error) {
	for _, att := range attendances {
		attendanceResponse, err := attendanceToAttendanceResponse(att)
		if err != nil {
			return responses, err
		}
		responses = append(responses, attendanceResponse)
	}
	return responses, nil
}

func attendanceToAttendanceResponse(att models.Attendance) (models.AttendanceResponse, error) {
	var attendanceResponse models.AttendanceResponse
	attendanceResponse.EventTime = att.EventTime
	attendanceResponse.EventType = att.EventType
	attendanceResponse.ExpectedTime = att.ExpectedTime
	attendanceResponse.Pending = att.Pending
	attendanceResponse, err := calcTimeDiff(attendanceResponse)
	attendanceResponse.AttendaceId = att.Id
	return attendanceResponse, err
}

// func queryUserDailyAttendance(id int64) ([]models.AttendanceResponse, error) {

// 	attendanceResponses := []models.AttendanceResponse{}
// 	attendances := []models.Attendance{}
// 	results, err := db.Query(getTodaysEventsQuery, id)
// 	if err != nil {
// 		return attendanceResponses, err
// 	}
// 	attendances, err = scanAttendanceRowListMinimal(results, attendances)
// 	if err != nil {
// 		return attendanceResponses, err
// 	}
// 	attendanceResponses, err = attendancesToAttendanceResponses(attendances, attendanceResponses)

// 	if err != nil {
// 		return attendanceResponses, err
// 	}

// 	return attendanceResponses, nil
// }

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
	return attendance, nil
}

// TODO: fix pending messages
func GetTodaysAttendance(id int64) ([]models.AttendanceResponse, error) {

	attendances, err := GetLastTwoEventsFromUser(id)
	if err != nil {
		ic.Ic(err.Error())
		return nil, err
	}
	today := time.Now()
	if len(attendances) == 2 {
		last := attendances[0]
		attendances[0] = attendances[1]
		attendances[1] = last
		t, err := utils.ParseDBTime(last.EventTime)
		if err != nil {
			ic.Ic(err.Error())
			return nil, err
		}
		if t.Format(data.DATE_FORMAT) == today.Format(data.DATE_FORMAT) {
			attendances = updateTimediffIfPending(attendances)
			return attendances, nil
		}
	}
	attendances, err = GenerateMissingAttendances(id, attendances, today)
	if err != nil {
		ic.Ic(err.Error())
		return nil, err
	}
	if len(attendances) < 2 {
		return nil, errors.New(fmt.Sprint(10))
	}
	var todayAttendances []models.AttendanceResponse = attendances[len(attendances)-2:]
	lastEventDay, err := utils.ParseDBTime(todayAttendances[0].EventTime)
	if err != nil {
		ic.Ic(err.Error())
		return nil, err
	}
	if today.Format(data.DATE_FORMAT) != lastEventDay.Format(data.DATE_FORMAT) {
		return nil, errors.New(fmt.Sprint(10))
	}
	todayAttendances = updateTimediffIfPending(todayAttendances)
	return todayAttendances, nil
}

func updateTimediffIfPending(attendances []models.AttendanceResponse) []models.AttendanceResponse {
	eventTimeNow := utils.GetTimeStringNow()
	for idx, att := range attendances {
		timeDiff, comments, _ := utils.GetFormattedTimeDiff(eventTimeNow, att.ExpectedTime, att.EventType == data.CHECK_IN)
		attendances[idx].Comments = comments
		attendances[idx].TimeDiff = timeDiff
	}
	ic.Ic(attendances)
	return attendances
}
func GenerateMissingAttendances(userId int64,
	attendances []models.AttendanceResponse, today time.Time) ([]models.AttendanceResponse, error) {

	var lastEventDay time.Time
	var err error
	lastEventDay = time.Now().AddDate(0, 0, -1)
	if len(attendances) != 0 {
		att := attendances[len(attendances)-1]
		lastEventDay, err = utils.ParseDBTime(att.EventTime)
		if err != nil {
			ic.Ic(err.Error())
			return attendances, err
		}
		attendances = attendances[:0]
	}

	// partir desde el dia siguiente al del ultimo evento registrado
	lastEventDay = lastEventDay.AddDate(0, 0, 1)
	ic.Ic(lastEventDay.String())
	shift, err := queryUsersCurrentShift(userId)
	if err != nil {
		ic.Ic(err.Error())
		return attendances, err
	}

	// ver si el ultimo evento no es del futuro
	if today.Format(data.DATE_FORMAT) < lastEventDay.Format(data.DATE_FORMAT) {
		panic("ultimo evento es del futuro cry")
	}
	attendances = getMissingAttendances(shift, today, lastEventDay, attendances)
	err = BulkInsert(attendances, userId)
	if err != nil {
		ic.Ic(err.Error())
		return nil, err
	}

	return GetTodaysAttendance(userId)
}

func getMissingAttendances(shift models.Shift, today time.Time,
	lastDayWithAttendance time.Time, attendances []models.AttendanceResponse) []models.AttendanceResponse {
	if today.Format(data.DATE_FORMAT) == lastDayWithAttendance.Format(data.DATE_FORMAT) {
		if len(attendances) > 0 {
			return attendances
		}
	}
	if attendances == nil {
		attendances = []models.AttendanceResponse{}
	}
	var shiftTime string
	var timeDiff, comments string
	for today.Format(data.DATE_FORMAT) >= lastDayWithAttendance.Format(data.DATE_FORMAT) {
		weekday := lastDayWithAttendance.Weekday().String()
		// ic.Ic(lastDayWithAttendance.String())
		isWorkday := isWorkday(shift, weekday)
		if isWorkday {
			for i := 0; i < 2; i++ {
				var attendance models.AttendanceResponse
				if i == 0 {
					shiftTime = shift.CheckInTime
				} else {
					shiftTime = shift.CheckOutTime
				}
				attendance.EventType = data.AttendanceEventTypes[i]
				attendance.EventTime = lastDayWithAttendance.Format(data.DATE_FORMAT) + " " + data.NO_TIME_DIFF
				attendance.ExpectedTime = shiftTime
				attendance.Pending = true
				if today.Format(data.DATE_FORMAT) == lastDayWithAttendance.Format(data.DATE_FORMAT) {
					eventTimeNow := utils.GetTimeStringNow()
					timeDiff, comments, _ = utils.GetFormattedTimeDiff(eventTimeNow,
						attendance.ExpectedTime, i == 0)
				} else {
					timeDiff = data.NO_TIME_DIFF
					comments = data.PENDING
				}
				attendance.TimeDiff = timeDiff
				attendance.Comments = comments
				attendances = append(attendances, attendance)
			}
		}
		lastDayWithAttendance = lastDayWithAttendance.AddDate(0, 0, 1)
	}
	return attendances
}

func isWorkday(shift models.Shift, weekday string) bool {
	workdays := strings.Split(shift.Workdays, ",")
	return utils.StringInSliceLowercase(weekday, workdays)
}

// func generateTodaysAttendances(id int64, attendances []models.AttendanceResponse) ([]models.AttendanceResponse, error) {

// 	shift, err := queryUsersCurrentShift(id)
// 	if err != nil {
// 		return attendances, err
// 	}
// 	var shiftTime string
// 	var attendance models.AttendanceResponse
// 	for i := 0; i < 2; i++ {
// 		if i == 0 {
// 			shiftTime = shift.CheckInTime
// 		} else {
// 			shiftTime = shift.CheckOutTime
// 		}
// 		attendance.EventType = data.AttendanceEventTypes[i]
// 		attendance.EventTime = time.Now().Format(data.DATE_FORMAT) + " " + data.NO_TIME_DIFF
// 		attendance.ExpectedTime = shiftTime
// 		attendance.Pending = true

// 		eventTimeNow := utils.GetTimeStringNow()
// 		timeDiff, comments, _ := utils.GetFormattedTimeDiff(eventTimeNow,
// 			attendance.ExpectedTime, i == 0)
// 		attendance.TimeDiff = timeDiff
// 		attendance.Comments = comments
// 		attendances = append(attendances, attendance)
// 	}
// 	return attendances, nil
// }

func queryUsersCurrentShift(id int64) (models.Shift, error) {

	var shift models.Shift
	row := db.QueryRow(getUserShiftQuery, id)
	err := row.Scan(
		&shift.Id,
		&shift.CheckInTime,
		&shift.CheckOutTime,
		&shift.LunchBreakLength,
		&shift.Workdays,
	)
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
	return shift, nil
}

func DoIHaveToWorkTomorrow(id int64) (bool, error) {

	shift, err := queryUsersCurrentShift(id)
	if err != nil {
		ic.Ic(err.Error())
		return false, err
	}
	tomorrow := time.Now().AddDate(0, 0, 1).Weekday().String()
	return isWorkday(shift, tomorrow), nil
}

func GetAttendanceById(id int64) (models.Attendance, error) {

	row := db.QueryRow("SELECT * FROM attendance WHERE id = ?", id)
	attendance, err := scanAttendanceRow(row)
	return attendance, err
}

func GetAttendanceFromUser(id int64) ([]models.Attendance, error) {

	attendances := []models.Attendance{}
	results, err := db.Query("SELECT * FROM attendance WHERE user_id = ?", id)
	if err != nil && err != sql.ErrNoRows {
		return attendances, err
	}
	attendances, err = scanAttendanceRowList(results)
	return attendances, err
}

func GetMonthlyCompanyAttendance(userId int64) (map[int]models.UserMonthlyAttendance, error) {

	user, err := GetUserById(userId)
	if err != nil {
		return nil, err
	}
	if user.Role != data.ADMIN_ROLE {
		return nil, errors.New(fmt.Sprint(13))
	}
	// attendances := []models.Attendance{}
	results, err := db.Query(monthlyCompanyAttendanceQuery, userId)
	if err != nil && err != sql.ErrNoRows {
		return nil, err
	}
	attendances, err := scanAttendanceRowList(results)
	if err != nil {
		return nil, err
	}
	var idToMonthlyAttendancesMap = map[int]models.UserMonthlyAttendance{}
	for _, att := range attendances {
		v, exist := idToMonthlyAttendancesMap[att.UserId]
		if !exist {
			var userMonthlyAtt models.UserMonthlyAttendance
			user, err := GetUserById(int64(att.UserId))
			if err != nil {
				return nil, err
			}
			userMonthlyAtt.UserId = att.UserId
			userMonthlyAtt.UserRole = user.Role
			userMonthlyAtt.UserRut = user.Rut
			userMonthlyAtt.UserPictureUrl = data.PRODUCTION_URL + data.USER_PIC_LOCATION + fmt.Sprint(user.Id)
			// userMonthlyAtt.Attendances = []models.AttendanceResponse{}
			idToMonthlyAttendancesMap[att.UserId] = userMonthlyAtt
			v = idToMonthlyAttendancesMap[att.UserId]
		}
		attResp, err := attendanceToAttendanceResponse(att)
		if err != nil {
			return nil, err
		}
		v.Attendances = append(v.Attendances, attResp)
		idToMonthlyAttendancesMap[att.UserId] = v
	}

	// var attendanceResponses = []models.AttendanceResponse{}
	// attendanceResponses, err = attendancesToAttendanceResponses(attendances, attendanceResponses)

	return idToMonthlyAttendancesMap, err
}
func GetAttendances() ([]models.Attendance, error) {

	results, err := db.Query("SELECT * FROM attendance;")

	if err != nil {
		fmt.Println("Err", err.Error())
		return nil, err
	}

	attendances, err := scanAttendanceRowList(results)
	return attendances, err

}

func BulkInsert(unsavedRows []models.AttendanceResponse, userId int64) error {
	if len(unsavedRows) == 0 {
		return errors.New(fmt.Sprint(10))
	}
	valueStrings := make([]string, 0, len(unsavedRows))
	valueArgs := make([]interface{}, 0, len(unsavedRows)*7)
	var comments string
	for _, post := range unsavedRows {
		if post.Pending {
			comments = data.PENDING
		} else {
			comments = post.Comments
		}
		valueStrings = append(valueStrings, "(?, ?, ?, ?, ?, ?, ?)")
		valueArgs = append(valueArgs, userId)
		valueArgs = append(valueArgs, "0,0") //location
		valueArgs = append(valueArgs, post.EventType)
		valueArgs = append(valueArgs, post.EventTime)
		valueArgs = append(valueArgs, post.ExpectedTime)
		valueArgs = append(valueArgs, post.Pending)
		valueArgs = append(valueArgs, comments)
	}
	stmt := fmt.Sprintf("INSERT INTO attendance (user_id, location, event_type, event_time, expected_time, pending, comments) VALUES %s",
		strings.Join(valueStrings, ","))
	_, err := db.Exec(stmt, valueArgs...)
	return err
}
