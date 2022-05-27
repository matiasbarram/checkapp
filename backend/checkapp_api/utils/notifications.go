package utils

import (
	"checkapp_api/data"
	"checkapp_api/models"
	"context"
	"fmt"

	//"fmt"
	//"os"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/WAY29/icecream-go/icecream"
	_ "github.com/go-sql-driver/mysql"
	"google.golang.org/api/option"

	"github.com/joho/godotenv"
)

var _ = godotenv.Load(".env") // Cargar del archivo llamado ".env"
var app *firebase.App
var cli *messaging.Client

// InitDB sets up setting up the connection pool global variable.
func InitFirebaseApp() error {
	var err error
	opt := option.WithCredentialsFile(data.FIREBASE_JSON)
	app, err = firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		icecream.Ic(err.Error())
		return err
	}
	err = getMessagingClient()
	if err != nil {
		icecream.Ic(err.Error())
		return err
	}
	fmt.Println("Firebase OK")
	return nil
}

func getMessagingClient() error {
	var err error

	cli, err = app.Messaging(context.Background())
	if err != nil {
		return err
	}
	return nil
}

func SendMessage(title string, body string, token string) (string, error) {

	var response string
	response, err := cli.Send(context.Background(), &messaging.Message{

		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Token: token,
	})
	if err != nil {
		icecream.Ic(err.Error())
		return response, err
	}
	return response, nil
}

func NotifyAdmin(userId int64, attendance models.AttendanceResponse) error {
	fmt.Println("user idL ", userId)
	fmt.Println("attendance: ", attendance)
	// el usuario x registro satifactoriamente su $eventype a las $eventime

	return nil
}
