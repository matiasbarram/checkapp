package main

import (
	"bytes"
	"checkapp_api/models"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/WAY29/icecream-go/icecream"
	"github.com/stretchr/testify/assert"
)

//const testEmail = "josevasquez95p@gmail.com"
const testEmail = "mjm@sml.com"

//const testPassword = "joselo"
const testPassword = "bruh"
const testUserId = 2

func TestLoginHandler(t *testing.T) {
	param := make(map[string]interface{})
	param["email"] = testEmail
	param["password"] = testPassword
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", ApiV1+"login", bytes.NewBuffer(jsonValue))
	req.Header.Add("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	myCookie = w.Result().Cookies()[0].Value
	var response map[string]interface{}
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	var user models.User
	jsonValue, err = json.Marshal(response["user"])
	assert.Nil(t, err)
	json.Unmarshal(jsonValue, &user)
	assert.Nil(t, err)
	assert.True(t, user.Email == param["email"])
}

func TestGetUsers(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"users", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response []models.User
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.True(t, (len(response) > 0))
	value := response[0]
	assert.True(t, value.Id > 0)
}

func TestGetUserById(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"users/2", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response models.User
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	icecream.Ic(response)
	assert.True(t, response.Id == 2)
}

func TestGetCompanies(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"companies", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response []models.Company
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.True(t, (len(response) > 0))
	value := response[0]
	assert.True(t, value.Id > 0)
}

func TestGetCompanyById(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"companies/1", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response models.Company
	err := json.Unmarshal(w.Body.Bytes(), &response)
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetMyCompany(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"companies/me", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response models.Company
	err := json.Unmarshal(w.Body.Bytes(), &response)
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetQrs(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"qrs", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response []models.Qr
	err := json.Unmarshal(w.Body.Bytes(), &response)
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, (len(response) > 0))
	value := response[0]
	assert.True(t, value.Id > 0)
}

func TestGetQrById(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"qrs/1", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response models.Qr
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetMe(t *testing.T) {
	w := httptest.NewRecorder()
	// http.SetCookie(w, )
	req, _ := http.NewRequest("GET", PrivateUrl+"users/me", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	// fmt.Println(w.coo)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	// var response models.Qr
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	// assert.Nil(t, err)
	// assert.True(t, response.Id == 1)
}

//func TestPostAttendance(t *testing.T) {
//param := make(map[string]interface{})
//param["user_id"] = 2
//param["company_id"] = 1
//param["location"] = "-30, -70"
//param["event_type"] = "CHECK_IN"
//jsonValue, _ := json.Marshal(param)
//w := httptest.NewRecorder()
//req, _ := http.NewRequest("POST", PrivateUrl+"attendance", bytes.NewBuffer(jsonValue))
//req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
//req.Header.Add("Content-Type", "application/json")
//r.ServeHTTP(w, req)
//assert.True(t, (w.Code == 200 || w.Code == 400))
//var resp map[string]interface{}
//err := json.Unmarshal(w.Body.Bytes(), &resp)
//assert.Nil(t, err)
//if w.Code == 200 {
//var response models.Attendance
//jsonValue, err = json.Marshal(resp["attendance"])
//assert.Nil(t, err)
//err = json.Unmarshal(jsonValue, &response)
//assert.Nil(t, err)
//assert.True(t, response.EventType == "CHECK_IN")
//} else {
//var response models.SimpleError
//jsonValue, err = json.Marshal(resp["error"])
//assert.Nil(t, err)
//err = json.Unmarshal(jsonValue, &response)
//assert.Nil(t, err)
//assert.True(t, response.Code < 13)
//}
//}

func TestGetTodayAttendance(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", PrivateUrl+"attendance/today", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response []models.AttendanceResponse
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.Len(t, response, 2)
}

//func TestResetDailyAttendance(t *testing.T) {
//w := httptest.NewRecorder()
//req, _ := http.NewRequest("GET", ApiV1+"reset/attendance/today", nil)
//req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
//r.ServeHTTP(w, req)
//assert.Equal(t, 200, w.Code)
//}

func TestLogout(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", ApiV1+"logout", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
}
