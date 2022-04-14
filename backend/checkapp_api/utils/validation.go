package utils

import (
	"errors"
	"fmt"
	"strconv"

	"github.com/go-playground/validator/v10"
)

// type ErrorMsg struct {
// 	Field   string `json:"field"`
// 	Message string `json:"message"`
// }

// func getErrorMsg(fe validator.FieldError) string {
// 	switch fe.Tag() {
// 	case "required":
// 		return "This field is required"
// 	case "lte":
// 		return "Should be less than " + fe.Param()
// 	case "gte":
// 		return "Should be greater than " + fe.Param()
// 	}
// 	return "Unknown error"
// }

func SimpleValidationErrors(verr validator.ValidationErrors) map[string]string {
	errs := make(map[string]string)
	for _, f := range verr {
		err := f.ActualTag()
		if f.Param() != "" {
			err = fmt.Sprintf("%s=%s", err, f.Param())
		}
		errs[f.Field()] = err
	}
	return errs
}

func isEmpty(v string) bool {
	return len(v) > 0
}

func ValidateId(str_num string, field_name string) (int64, error) {
	if isEmpty(str_num) {
		return -1, errors.New("Got an empty value at " + field_name)
	}

	i, err := strconv.ParseInt(str_num, 10, 64)
	if err != nil {
		return -1, err
	}
	return i, nil
}

func StringInSlice(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}
