package models

type Company struct {
	Id       int    `json:"id"`
	Name     string `json:"name"`
	Location string `json:"location"`
}
