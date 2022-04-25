package models

type SimpleError struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}
