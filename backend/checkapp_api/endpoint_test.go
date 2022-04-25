package main

import (
	"bytes"
	"checkapp_api/models"
	"checkapp_api/router"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var r *gin.Engine
var myCookie string

// var w *httptest.ResponseRecorder

func init() {
	r = router.Setup()
}

func TestHomeEndpoint(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/", nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
	// assert.Equal(t, "pong", w.Body.String())
}

func TestGetUsers(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/users", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response []models.User
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, (len(response) > 0))
	value := response[0]
	assert.True(t, value.Id > 0)
}
func TestGetUserById(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/users/2", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.User
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 2)
}

func TestGetCompanies(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/companies", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response []models.Company
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, (len(response) > 0))
	value := response[0]
	assert.True(t, value.Id > 0)
}

func TestGetCompanyById(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/companies/1", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.Company
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetQrs(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/qrs", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response []models.Qr
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, (len(response) > 0))
	value := response[0]
	assert.True(t, value.Id > 0)
}

func TestGetQrById(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/qrs/1", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.Qr
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetQrImage(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/qrs/image/1", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, w.Result().Header.Get("Content-Type"), "image/jpeg")
}
func TestBadLogin(t *testing.T) {
	param := make(map[string]interface{})
	param["email"] = "smj@sml.com"
	param["password"] = "fakepass"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/v1/login", bytes.NewBuffer(jsonValue))
	req.Header.Add("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	var response map[string]interface{}
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	fmt.Println(response)
	assert.Equal(t, 401, w.Code)
	assert.Nil(t, err)
	assert.Equal(t, "Authentication failed LAPASS", response["error"])
}
func TestLoginHandler(t *testing.T) {
	param := make(map[string]interface{})
	param["email"] = "smj@sml.com"
	param["password"] = "tomandoleche123"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/v1/login", bytes.NewBuffer(jsonValue))
	req.Header.Add("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	myCookie = w.Result().Cookies()[0].Value
	var response map[string]interface{}
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	var user models.User
	jsonValue, err = json.Marshal(response["user"])
	assert.Nil(t, err)
	json.Unmarshal(jsonValue, &user)
	assert.Nil(t, err)
	assert.True(t, user.Email == param["email"])
}

func TestGetMe(t *testing.T) {

	w := httptest.NewRecorder()
	// http.SetCookie(w, )
	req, _ := http.NewRequest("GET", "/api/v1/private/me", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	// fmt.Println(w.coo)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	// var response models.Qr
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	// assert.Nil(t, err)
	// assert.True(t, response.Id == 1)
}

func TestLogout(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/v1/logout", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
}

func TestAttendance(t *testing.T) {
	param := make(map[string]interface{})
	param["user_id"] = 2
	param["company_id"] = 1
	param["location"] = "-30, -70"
	param["event_type"] = "AUTO"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/v1/private/attendance", bytes.NewBuffer(jsonValue))
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	req.Header.Add("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var resp map[string]interface{}
	err := json.Unmarshal([]byte(w.Body.String()), &resp)
	var response models.Attendance
	jsonValue, err = json.Marshal(resp["attendance"])
	assert.Nil(t, err)
	json.Unmarshal(jsonValue, &response)

	assert.Nil(t, err)
	// assert.True(t, attendance.Id == param["user_id"])
	assert.True(t, (response.EventType == "CHECK_IN" || response.EventType == "CHECK_OUT"))
}

func TestGetMyLastAttendance(t *testing.T) {

	w := httptest.NewRecorder()
	// http.SetCookie(w, )
	req, _ := http.NewRequest("GET", "/api/v1/private/attendance/last", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	// fmt.Println(w.coo)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response models.Attendance
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.Equal(t, 2, response.UserId)

	// assert.True(t, response.Id == 1)
}
