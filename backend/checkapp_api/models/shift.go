package models

type Shift struct {
	Id               int    `json:"id"`
	CheckInTime      string `json:"check_in_time"`
	CheckOutTime     string `json:"check_out_time"`
	LunchBreakLength int    `json:"lunch_break_time"`
}
