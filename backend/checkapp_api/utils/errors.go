package utils

import (
	"checkapp_api/data"
	"checkapp_api/models"
	"strconv"
)

func GenerateResponseError(err error) models.SimpleError {
	var responseError models.SimpleError
	i, err2 := strconv.ParseInt(err.Error(), 10, 64)
	if err2 != nil {
		responseError.Code = 0
		responseError.Message = err.Error()
	} else {
		responseError.Code = int(i)
		responseError.Message = data.ErrorCodeMap[int(i)]
	}
	return responseError
}

func GenerateResponseErrorWithCode(err error) (models.SimpleError, int) {
	var responseError models.SimpleError
	var httpErrorCode int
	i, err2 := strconv.ParseInt(err.Error(), 10, 64)
	if err2 != nil {
		responseError.Code = 0
		responseError.Message = err.Error()
	} else {
		responseError.Code = int(i)
		responseError.Message = data.ErrorCodeMap[int(i)]
	}
	if responseError.Code == 0 {
		httpErrorCode = 500
	} else if responseError.Code == 13 {
		httpErrorCode = 401
	} else {
		httpErrorCode = 400
	}
	return responseError, httpErrorCode
}
