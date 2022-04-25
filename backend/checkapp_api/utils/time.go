package utils

import (
	"fmt"
	"math"
	"strings"
	"time"

	ic "github.com/WAY29/icecream-go/icecream"
)

func GetTimeDiffSeconds(eventTime string, targetTime string, isArrival bool) (float64, error) {
	t1, err := time.Parse(time.RFC3339, strings.Replace(eventTime, " ", "T", 1)+"-04:00")
	if err != nil {
		ic.Ic(eventTime)
		return 0, err
	}

	year, month, day := time.Now().Date()
	todayString := fmt.Sprintf("%d-%02d-%02dT", year, month, day)
	t2, _ := time.Parse(time.RFC3339, todayString+targetTime+"-04:00")
	if err != nil {
		ic.Ic(targetTime)
		return 0, err
	}
	// var diff time.Duration
	// if isArrival {
	// diff = t1.Sub(t2)

	// } else {
	diff := t2.Sub(t1)
	// }
	ic.Ic(diff)
	return diff.Seconds(), nil
}

func FormatSecondsToHHMMSS(seconds float64) string {
	if seconds < 0 {
		ic.Ic(seconds, " NEGATIVE")
	}
	seconds = math.Abs(seconds)
	hours := math.Floor(seconds / 60 / 60)
	minutes := int(seconds) % 3600 / 60
	remainderSeconds := int(seconds) % 3600 % 60
	formatedSeconds := fmt.Sprintf("%02d:%02d:%02d", int(hours), int(minutes), remainderSeconds)
	return formatedSeconds
}

func GetFormattedTimeDiff(eventTime string, expectedTime string, isArrival bool) (string, string, error) {
	diff, err := GetTimeDiffSeconds(eventTime, expectedTime, isArrival)
	if err != nil {
		return "", "", err
	}
	var comments string
	if isArrival && diff < 0 {
		comments = "LATE ARRIVAL"
	} else if !isArrival && diff > 0 {
		comments = "EARLY LEAVE"
	} else {
		comments = "ON TIME"
	}
	timeDiff := FormatSecondsToHHMMSS(diff)
	return timeDiff, comments, nil
}

func GetTimeStringNow() string {
	t := time.Now()
	return t.Format("2006-01-02 15:04:05")
}
