package models

import (
	"database/sql"
	"encoding/json"
)

type MyNullString struct {
	sql.NullString
}

func (s MyNullString) MarshalJSON() ([]byte, error) {
	if s.Valid {
		return json.Marshal(s.String)
	}
	return []byte(`null`), nil
}

type User struct {
	Id         int    `form:"id"`
	Company_id int    `form:"company_id" binding:"required"`
	Name       string `form:"name" binding:"required"`
	Rut        string `form:"rut" binding:"required"`
	Role       string `form:"role" binding:"required"`
	Email      string `form:"email" binding:"required"`
	Password   string `form:"password,omitempty" binding:"required,len>4"`
	Device_id  int    `form:"device_id,omitempty"`
}

type UserCredentials struct {
	Email    string `form:"email" binding:"required"`
	Password string `form:"password" binding:"required"`
	// Device_id int    `json:"device_id,omitempty" `
}

type UserAttendanceInfo struct {
	Id                int    `json:"id"`
	Company_id        int    `json:"company_id"`
	Name              string `json:"name"`
	Company           string `json:"company"`
	Company_location  string `json:"company_location"`
	Device_secret_key string `json:"device_secret_key"`
	Check_in_time     string `json:"check_in_time"`
	Check_out_time    string `json:"check_out_time"`
}

type UserLoginResponse struct {
	Message string `json:"message"`
	User    User   `json:"id"`
}
