package models

import (
	"time"
)

type Attendance struct {
	Id         int       `json:"id"`
	User_id    int       `json:"user_id"`
	Event_type string    `json:"event_type"`
	Event_time time.Time `json:"event_time"`
	Location   string    `json:"location"`
}

type AttendanceParams struct {
	User_id           int    `json:"user_id"`
	Company_id        int    `json:"company_id"`
	Location          string `json:"location"`
	Device_secret_key string `json:"device_secret_key"`
	Event_type        string `json:"event_type"`
}
