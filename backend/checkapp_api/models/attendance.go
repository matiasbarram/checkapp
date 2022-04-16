package models

type Attendance struct {
	Id         int    `json:"id"`
	User_id    int    `json:"user_id"`
	Event_type string `json:"event_type"`
	Event_time string `json:"event_time"`
	Location   string `json:"location"`
	Confirmed  bool   `json:"confirmed"`
	Comments   string `json:"comments,omitempty"`
}

type AttendanceParams struct {
	User_id           int    `json:"user_id" binding:"required"`
	Company_id        int    `json:"company_id,omitempty" binding:"required"`
	Location          string `json:"location,omitempty"`
	Device_secret_key string `json:"device_secret_key,omitempty"`
	Event_type        string `json:"event_type,omitempty"`
	Comments          string `json:"comments,omitempty"`
}
