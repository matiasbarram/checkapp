package main

import (
	"bytes"
	"checkapp_api/models"
	"checkapp_api/router"
	"encoding/json"
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
	req, _ := http.NewRequest("GET", "/", nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
	// assert.Equal(t, "pong", w.Body.String())
}

func TestGetUsers(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/users", nil)
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
	req, _ := http.NewRequest("GET", "/users/2", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.User
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 2)
}

func TestGetCompanies(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/companies", nil)
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
	req, _ := http.NewRequest("GET", "/companies/1", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.Company
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetQrs(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/qrs", nil)
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
	req, _ := http.NewRequest("GET", "/qrs/1", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	var response models.Qr
	err := json.Unmarshal([]byte(w.Body.String()), &response)
	assert.Nil(t, err)
	assert.True(t, response.Id == 1)
}

func TestGetQrImage(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/qrs/image/1", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, w.Result().Header.Get("Content-Type"), "image/jpeg")
}
func TestBadLogin(t *testing.T) {
	param := make(map[string]interface{})
	param["email"] = "fake@mail.com"
	param["password"] = "fakepass"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/login", bytes.NewBuffer(jsonValue))
	r.ServeHTTP(w, req)
	assert.Equal(t, 401, w.Code)
}
func TestLoginHandler(t *testing.T) {
	param := make(map[string]interface{})
	param["email"] = "smj@sml.com"
	param["password"] = "tomandoleche123"
	jsonValue, _ := json.Marshal(param)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/login", bytes.NewBuffer(jsonValue))
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
	req, _ := http.NewRequest("GET", "/private/me", nil)
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
	req, _ := http.NewRequest("GET", "/logout", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
}
