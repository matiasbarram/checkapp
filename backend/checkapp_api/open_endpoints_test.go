package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHomeEndpoint(t *testing.T) {

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", ApiV1, nil)
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
	req, _ := http.NewRequest("POST", ApiV1+"login", bytes.NewBuffer(jsonValue))
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

//func TestLoginHandler(t *testing.T) {
//param := make(map[string]interface{})
//param["email"] = "smj@sml.com"
//param["password"] = "tomandoleche123"
//jsonValue, _ := json.Marshal(param)
//w := httptest.NewRecorder()
//req, _ := http.NewRequest("POST", baseUrlOpen+"login", bytes.NewBuffer(jsonValue))
//req.Header.Add("Content-Type", "application/json")
//r.ServeHTTP(w, req)
//assert.Equal(t, 200, w.Code)

//myCookie = w.Result().Cookies()[0].Value
//var response map[string]interface{}
//// err := json.Unmarshal([]byte(w.Body.String()), &response)
//err := json.Unmarshal(w.Body.Bytes(), &response)
//assert.Nil(t, err)
//var user models.User
//jsonValue, err = json.Marshal(response["user"])
//assert.Nil(t, err)
//json.Unmarshal(jsonValue, &user)
//assert.Nil(t, err)
//assert.True(t, user.Email == param["email"])
//}

func TestGetUserImageById(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", OpenUrl+"users/image/2", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, w.Result().Header.Get("Content-Type"), "image/jpeg")
}

func TestGetQrImageById(t *testing.T) {
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", OpenUrl+"qrs/image/1", nil)
	req.AddCookie(&http.Cookie{Name: "mysession", Value: myCookie})
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, w.Result().Header.Get("Content-Type"), "image/jpeg")
}
