package models

// TODO: quitar lineas comentadas

type Attendance struct {
	Id           int    `json:"id"`
	UserId       int    `json:"user_id"`
	EventType    string `json:"event_type"`
	EventTime    string `json:"event_time"`
	Location     string `json:"location"`
	Pending      bool   `json:"pending"`
	Comments     string `json:"comments,omitempty"`
	ExpectedTime string `json:"expected_time"`
}

type AttendanceParams struct {
	// User_id           int    `form:"user_id" binding:"required"`
	Company_id        int    `form:"company_id,omitempty" binding:"required"`
	Location          string `form:"location,omitempty"`
	Device_secret_key string `form:"device_secret_key,omitempty"`
	Event_type        string `form:"event_type,omitempty"`
	Comments          string `form:"comments,omitempty"`
}

type AttendanceResponse struct {
	AttendaceId  int    `json:"attendance_id"`
	EventType    string `json:"event_type"`
	ExpectedTime string `json:"expected_time"`
	Pending      bool   `json:"pending"`
	EventTime    string `json:"event_time,omitempty"`
	// pending    bool   `json:"pending"`
	Comments string `json:"comments,omitempty"`
	TimeDiff string `json:"time_diff,omitempty"`
	// Punctual     bool   `json:"Punctual,omitempty"`
}
