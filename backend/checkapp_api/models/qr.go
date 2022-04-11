package models

type Qr struct {
	Id         int    `json:"id"`
	Company_id int    `json:"company_id"`
	Content    []byte `json:"content"`
}
