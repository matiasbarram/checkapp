package utils

import (
	"checkapp_api/data"
	"checkapp_api/models"
	"errors"
	"fmt"
	"net/mail"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

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
		if strings.Compare(a, b) == 0 {
			return true
		}
	}
	return false
}

func ValidateUserInfo(c *gin.Context) (models.User, error) {
	var u models.User
	err := c.ShouldBind(&u)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			return u, errors.New(fmt.Sprint(SimpleValidationErrors(verr)))
		}
	}
	// validar de mejor forma...
	// if len(u.Password) < 4 {
	// 	return u, errors.New("password too short")
	// }
	_, err = mail.ParseAddress(u.Email)
	if err != nil {
		return u, err
	}
	return u, nil
}

func ValidateAttendanceParams(c *gin.Context) (models.AttendanceParams, error) {
	var att models.AttendanceParams
	att.Event_type = "NEXT"
	// jsonData, err := ioutil.ReadAll(c.Request.Body)
	err := c.ShouldBind(&att)
	if err != nil {
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			return att, errors.New(fmt.Sprint(SimpleValidationErrors(verr)))
		}
	}
	return att, nil
}

func ValidateUserLocation(userLocation string, companyLocation string) error {
	distance, err := CalculateDistance(userLocation, companyLocation)
	if err != nil {
		return err
	}

	if distance > data.AttendanceDistanceLimit {
		return errors.New("you are too far away from your company 💢 (distance : " + fmt.Sprintf("%.2f", distance) + " km)")
	}
	return nil
}

func ValidateLoginArgs(c *gin.Context) (models.UserCredentials, error) {
	var u models.UserCredentials
	err := c.ShouldBind(&u)
	if err != nil {
		fmt.Println("binding error!")
		var verr validator.ValidationErrors
		if errors.As(err, &verr) {
			return u, errors.New(fmt.Sprint(SimpleValidationErrors(verr)))
		}
	}
	// validar de mejor forma...
	// if len(u.Password) < 4 {
	// 	return u, errors.New("password too short")
	// }
	_, err = mail.ParseAddress(u.Email)
	if err != nil {
		return u, err
	}
	return u, nil
}
