package data

import (
	"github.com/go-playground/validator/v10"
)

const UserKey = "user"

const AttendanceDistanceLimit = 0.75 // km

var AttendaceEventTypes = [2]string{"CHECK_IN", "CHECK_OUT"}

var Validate *validator.Validate
