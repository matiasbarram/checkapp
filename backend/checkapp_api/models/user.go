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
	Id         int    `json:"id"`
	Company_id int    `json:"company_id" binding:"required"`
	Name       string `json:"name" binding:"required"`
	Rut        string `json:"rut" binding:"required"`
	Role       string `json:"role" binding:"required"`
	Email      string `json:"email" binding:"required"`
	Password   string `json:"password,omitempty" binding:"required"`
	Device_id  int    `json:"device_id,omitempty" `
}

type UserCredentials struct {
	Email     string `json:"email" binding:"required"`
	Password  string `json:"password" binding:"required"`
	Device_id int    `json:"device_id,omitempty" `
}

type UserAttendanceInfo struct {
	Id                int    `json:"id"`
	Name              int    `json:"name"`
	Company_id        int    `json:"company_id"`
	Company           string `json:"company"`
	Company_location  string `json:"company_location"`
	Device_secret_key string `json:"device_secret_key"`
}
