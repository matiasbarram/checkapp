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
	// User_id           int    `form:"user_id" binding:"required"`
	Company_id        int    `form:"company_id,omitempty" binding:"required"`
	Location          string `form:"location,omitempty"`
	Device_secret_key string `form:"device_secret_key,omitempty"`
	Event_type        string `form:"event_type,omitempty"`
	Comments          string `form:"comments,omitempty"`
}
