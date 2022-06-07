package utils

import (
	"checkapp_api/data"
	"checkapp_api/models"
	"context"
	"fmt"
	"time"

	//"fmt"
	//"os"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/WAY29/icecream-go/icecream"
	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
	"github.com/mailgun/mailgun-go/v3"
	"google.golang.org/api/option"
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

func SendEmailNotifications(user models.NotificationRecipient,
	admins []models.NotificationRecipient,
	attendance models.AttendanceResponse) error {
	icecream.Ic(user)
	err := SendSimpleMessage(user, attendance, user.Name)
	if err != nil {
		icecream.Ic(err.Error())
		return err
	}
	for _, v := range admins {
		icecream.Ic(v)
		err = SendSimpleMessage(v, attendance, user.Name)
		if err != nil {
			icecream.Ic(err.Error())
			return err
		}
	}
	return nil
}

func SendSimpleMessage(user models.NotificationRecipient, attendance models.AttendanceResponse, attendee string) error {
	icecream.Ic(data.MAILGUN_API_KEY)
	mg := mailgun.NewMailgun(data.MailDomain, data.MAILGUN_API_KEY)
	m := mg.NewMessage(
		fmt.Sprintf("CheckApp Notifications <mailgun@%s>", data.MailDomain),    // from
		fmt.Sprintf("%s At %s registered", attendance.EventType, user.Company), // subject
		fmt.Sprintf("%s successfully did a %s at %s at %s", attendee,
			attendance.EventType,
			user.Company,
			attendance.EventTime),
		user.Email,
	)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*30)
	defer cancel()

	_, _, err := mg.Send(ctx, m)
	return err
}
