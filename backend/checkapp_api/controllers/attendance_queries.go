package controllers

const attendanceQuery = `
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
INSERT INTO attendance (user_id, location, event_type, pending, comments, expected_time) VALUES (?, ?, ?, ?, ?, ?)
`

// const lastTwoEventsFromUserQuery = `
// SELECT * FROM attendance WHERE user_id = ? ORDER BY id DESC LIMIT 2;
// `
const getUserShiftQuery = `
SELECT * FROM shift WHERE id=(SELECT shift_id FROM user WHERE id = ?); 
`
const getTodaysEventsQuery = `
SELECT
    event_type,
	expected_time,
	event_time,
    pending
FROM
    attendance
WHERE
    user_id = ? AND DATE(event_time) = CURRENT_DATE
ORDER BY
    id
DESC
LIMIT 2
`

const getLastTwoEventsQuery = `
SELECT
    event_type,
	expected_time,
	event_time,
    pending,
    id
FROM
    attendance
WHERE (user_id = ?)
ORDER BY id DESC LIMIT 2 ;
`
const deleteTodaysAttendance = `
DELETE FROM attendance WHERE DATE(event_time) = CURRENT_DATE;
`
const deleteAllAttendance = `
DELETE FROM attendance;
`

const monthlyCompanyAttendanceQuery = `
SELECT a.* FROM attendance a
INNER JOIN user u ON u.id = a.user_id
WHERE u.company_id = (SELECT u.company_id FROM user u WHERE u.id = ?) AND a.event_time > CURRENT_DATE() - INTERVAL 1 MONTH;;`

const filteredCompanyAttendanceQuery = `
SELECT a.* FROM attendance a
INNER JOIN user u ON u.id = a.user_id
WHERE u.company_id = (SELECT u.company_id FROM user u WHERE u.id = ?)
AND (a.event_time BETWEEN ? AND ?)
AND u.name LIKE ?
AND u.role LIKE ?;
`

// AND u.name LIKE ?
// AND u.role LIKE ?;`

const updateQuery = `
UPDATE attendance
SET event_time = ?, location = ?, pending = ?, comments = ?
WHERE id = ?; `
