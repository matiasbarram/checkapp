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
	Device_id  int    `json:"device_id,omitempty" `
	Email      string `json:"email,omitempty"`
	Password   string `json:"password,omitempty"`
}
