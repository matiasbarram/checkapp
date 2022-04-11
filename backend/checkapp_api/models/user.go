package models

import "database/sql"

type User struct {
	Id         int            `json:"id"`
	Company_id int            `json:"company_id"`
	Name       string         `json:"name"`
	Rut        string         `json:"rut"`
	Role       string         `json:"role"`
	Device_id  sql.NullString `json:"device_id"`
}
