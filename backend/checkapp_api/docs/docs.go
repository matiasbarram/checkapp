// Package docs GENERATED BY SWAG; DO NOT EDIT
// This file was generated by swaggo/swag
package docs

import "github.com/swaggo/swag"

const docTemplate = `{
    "schemes": {{ marshal .Schemes }},
    "swagger": "2.0",
    "info": {
        "description": "{{escape .Description}}",
        "title": "{{.Title}}",
        "termsOfService": "http://swagger.io/terms/",
        "contact": {
            "name": "API Support",
            "url": "http://www.swagger.io/support",
            "email": "support@swagger.io"
        },
        "license": {
            "name": "Apache 2.0",
            "url": "http://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "version": "{{.Version}}"
    },
    "host": "{{.Host}}",
    "basePath": "{{.BasePath}}",
    "paths": {
        "/": {
            "get": {
                "description": "show api homepage",
                "produces": [
                    "text/html"
                ],
                "tags": [
                    "home"
                ],
                "summary": "api homepage",
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "string"
                        }
                    }
                }
            }
        },
        "/login": {
            "post": {
                "description": "lol",
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/login"
                ],
                "summary": "basic login",
                "parameters": [
                    {
                        "description": "user credentials (email and password)",
                        "name": "data",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/models.UserCredentials"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/models.UserLoginResponse"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "401": {
                        "description": "Unauthorized",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/private/attendance": {
            "post": {
                "description": "lol",
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/private/attendance"
                ],
                "summary": "registers attendance for current user",
                "parameters": [
                    {
                        "description": "The input Attendance struct",
                        "name": "data",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/models.AttendanceParams"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/models.AttendanceResponse"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "500": {
                        "description": "Internal Server Error",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/private/attendance/last": {
            "get": {
                "description": "show api homepage",
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/private/attendance/last"
                ],
                "summary": "returns current user's last attendance event",
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/models.Attendance"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "500": {
                        "description": "Internal Server Error",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/private/attendance/today": {
            "get": {
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/private/attendance/today"
                ],
                "summary": "returns current user's today's attendance",
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/models.AttendanceResponse"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    },
                    "500": {
                        "description": "Internal Server Error",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/qrs": {
            "get": {
                "description": "lol",
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/qrs"
                ],
                "summary": "retrieves all qrs (pagination pending)",
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "array",
                            "items": {
                                "$ref": "#/definitions/models.Qr"
                            }
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/qrs/{id}": {
            "get": {
                "description": "lol",
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/qrs/{id}"
                ],
                "summary": "retrieves qr by id",
                "parameters": [
                    {
                        "minimum": 1,
                        "type": "integer",
                        "description": "int valid",
                        "name": "int",
                        "in": "path",
                        "required": true
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "array",
                            "items": {
                                "$ref": "#/definitions/models.Qr"
                            }
                        }
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/users": {
            "get": {
                "description": "lol",
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/users"
                ],
                "summary": "retrieves all users (pagination pending)",
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "array",
                            "items": {
                                "$ref": "#/definitions/models.User"
                            }
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            },
            "post": {
                "description": "lol",
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/users"
                ],
                "summary": "creates a new user",
                "parameters": [
                    {
                        "description": "The input User struct",
                        "name": "data",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/models.User"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/models.User"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        },
        "/users/{id}": {
            "get": {
                "description": "lol",
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "/users/{id}"
                ],
                "summary": "retrieves user by id",
                "parameters": [
                    {
                        "minimum": 1,
                        "type": "integer",
                        "description": "int valid",
                        "name": "int",
                        "in": "path",
                        "required": true
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "array",
                            "items": {
                                "$ref": "#/definitions/models.User"
                            }
                        }
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {
                            "$ref": "#/definitions/models.SimpleError"
                        }
                    }
                }
            }
        }
    },
    "definitions": {
        "models.Attendance": {
            "type": "object",
            "properties": {
                "comments": {
                    "type": "string"
                },
                "confirmed": {
                    "type": "boolean"
                },
                "event_time": {
                    "type": "string"
                },
                "event_type": {
                    "type": "string"
                },
                "expected_time": {
                    "type": "string"
                },
                "id": {
                    "type": "integer"
                },
                "location": {
                    "type": "string"
                },
                "user_id": {
                    "type": "integer"
                }
            }
        },
        "models.AttendanceParams": {
            "type": "object",
            "required": [
                "company_id"
            ],
            "properties": {
                "comments": {
                    "type": "string"
                },
                "company_id": {
                    "description": "User_id           int    ` + "`" + `form:\"user_id\" binding:\"required\"` + "`" + `",
                    "type": "integer"
                },
                "device_secret_key": {
                    "type": "string"
                },
                "event_type": {
                    "type": "string"
                },
                "location": {
                    "type": "string"
                }
            }
        },
        "models.AttendanceResponse": {
            "type": "object",
            "properties": {
                "comments": {
                    "description": "Confirmed    bool   ` + "`" + `json:\"confirmed\"` + "`" + `",
                    "type": "string"
                },
                "event_time": {
                    "type": "string"
                },
                "event_type": {
                    "type": "string"
                },
                "expected_time": {
                    "type": "string"
                },
                "pending": {
                    "type": "boolean"
                },
                "time_diff": {
                    "type": "string"
                }
            }
        },
        "models.Qr": {
            "type": "object",
            "properties": {
                "company_id": {
                    "type": "integer"
                },
                "content": {
                    "type": "array",
                    "items": {
                        "type": "integer"
                    }
                },
                "id": {
                    "type": "integer"
                }
            }
        },
        "models.SimpleError": {
            "type": "object",
            "properties": {
                "code": {
                    "type": "integer"
                },
                "message": {
                    "type": "string"
                }
            }
        },
        "models.User": {
            "type": "object",
            "required": [
                "company_id",
                "email",
                "name",
                "password",
                "role",
                "rut"
            ],
            "properties": {
                "company_id": {
                    "type": "integer"
                },
                "device_id": {
                    "type": "integer"
                },
                "email": {
                    "type": "string"
                },
                "id": {
                    "type": "integer"
                },
                "name": {
                    "type": "string"
                },
                "password": {
                    "type": "string"
                },
                "role": {
                    "type": "string"
                },
                "rut": {
                    "type": "string"
                }
            }
        },
        "models.UserCredentials": {
            "type": "object",
            "required": [
                "email",
                "password"
            ],
            "properties": {
                "email": {
                    "type": "string"
                },
                "password": {
                    "type": "string"
                }
            }
        },
        "models.UserLoginResponse": {
            "type": "object",
            "properties": {
                "id": {
                    "$ref": "#/definitions/models.User"
                },
                "message": {
                    "type": "string"
                }
            }
        }
    },
    "securityDefinitions": {
        "BasicAuth": {
            "type": "basic"
        }
    }
}`

// SwaggerInfo holds exported Swagger Info so clients can modify it
var SwaggerInfo = &swag.Spec{
	Version:          "",
	Host:             "api.asiendosoftware.xyz",
	BasePath:         "/api/v1",
	Schemes:          []string{"http", "https"},
	Title:            "CheckApp Server API",
	Description:      "This is a server for gente xora",
	InfoInstanceName: "swagger",
	SwaggerTemplate:  docTemplate,
}

func init() {
	swag.Register(SwaggerInfo.InstanceName(), SwaggerInfo)
}
