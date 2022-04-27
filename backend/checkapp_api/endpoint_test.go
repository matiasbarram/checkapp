package main

import (
	"bytes"
	"checkapp_api/models"
	"checkapp_api/router"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/WAY29/icecream-go/icecream"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var r *gin.Engine
var myCookie string
var baseUrlOpen = "/api/v1/"
var baseUrl = baseUrlOpen + "private/"

// var w *httptest.ResponseRecorder

func init() {
	r = router.Setup()
	icecream.ConfigureIncludeContext(true)
}

func TestHomeEndpoint(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", baseUrlOpen, nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
	// assert.Equal(t, "pong", w.Body.String())
}

func TestBadLogin(t *testing.T) {
	param := make(map[string]interface{})
	param["email"] = "smj@sml.com"
	param["password"] = "fakepass"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", baseUrlOpen+"login", bytes.NewBuffer(jsonValue))
	req.Header.Add("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	var response map[string]interface{}
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
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
	req, _ := http.NewRequest("POST", baseUrlOpen+"login", bytes.NewBuffer(jsonValue))
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
	req, _ := http.NewRequest("GET", baseUrl+"users", nil)
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
	req, _ := http.NewRequest("GET", baseUrl+"users/2", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.User
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 2)
}

func TestGetCompanies(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", baseUrl+"companies", nil)
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
	req, _ := http.NewRequest("GET", baseUrl+"companies/1", nil)
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
	req, _ := http.NewRequest("GET", baseUrl+"companies/me", nil)
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
	req, _ := http.NewRequest("GET", baseUrl+"qrs", nil)
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
	req, _ := http.NewRequest("GET", baseUrl+"qrs/1", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.Qr
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetQrImage(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", baseUrl+"qrs/image/1", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, w.Result().Header.Get("Content-Type"), "image/jpeg")
}

func TestGetMe(t *testing.T) {

	w := httptest.NewRecorder()
	// http.SetCookie(w, )
	req, _ := http.NewRequest("GET", baseUrl+"users/me", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	// fmt.Println(w.coo)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	// var response models.Qr
	// err := json.Unmarshal([]byte(w.Body.String()), &response)
	// assert.Nil(t, err)
	// assert.True(t, response.Id == 1)
}

func TestPostAttendance(t *testing.T) {
	param := make(map[string]interface{})
	param["user_id"] = 2
	param["company_id"] = 1
	param["location"] = "-30, -70"
	param["event_type"] = "CHECK_IN"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", baseUrl+"attendance", bytes.NewBuffer(jsonValue))
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	req.Header.Add("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var resp map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	assert.Nil(t, err)
	var response models.Attendance
	jsonValue, err = json.Marshal(resp["attendance"])
	assert.Nil(t, err)
	err = json.Unmarshal(jsonValue, &response)
	assert.Nil(t, err)
	assert.True(t, response.EventType == "CHECK_IN")
}

func TestGetTodayAttendance(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", baseUrl+"attendance/today", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	var response []models.AttendanceResponse
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.Nil(t, err)
	assert.Len(t, response, 2)
}

func TestResetDailyAttendance(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", baseUrlOpen+"reset/attendance/today", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
}

func TestLogout(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", baseUrlOpen+"logout", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
}
