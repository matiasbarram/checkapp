package utils

import (
	"checkapp_api/data"
	"fmt"
	"math"
	"strings"
	"time"

	ic "github.com/WAY29/icecream-go/icecream"
)

func ParseDBTime(eventTime string) (time.Time, error) {
	t1, err := time.Parse(time.RFC3339, strings.Replace(eventTime, " ", "T", 1)+"-04:00")
	return t1, err
}

func GetTimeDiffSeconds(eventTime string, targetTime string, isArrival bool) (float64, error) {
	t1, err := time.Parse(time.RFC3339, strings.Replace(eventTime, " ", "T", 1)+"-04:00")
	if err != nil {
		ic.Ic(eventTime)
		return 0, err
	}

	year, month, day := t1.Date()
	eventDayString := fmt.Sprintf("%d-%02d-%02dT", year, month, day)
	t2, _ := time.Parse(time.RFC3339, eventDayString+targetTime+"-04:00")
	if err != nil {
		ic.Ic(targetTime)
		return 0, err
	}
	diff := t2.Sub(t1)
	return diff.Seconds(), nil
}

func FormatSecondsToHHMMSS(seconds float64) string {
	// if seconds < 0 {
	// 	ic.Ic(seconds, " NEGATIVE")
	// }
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
	if isArrival && diff/60 < data.AttendanceTimeOffsetLimit {
		comments = data.LATE_ARRIVAL
	} else if !isArrival && diff/60 > data.AttendanceTimeOffsetLimit {
		comments = data.EARLY_LEAVE
	} else {
		comments = data.ON_TIME
	}
	timeDiff := FormatSecondsToHHMMSS(diff)
	return timeDiff, comments, nil
}

func GetTimeStringNow() string {
	t := time.Now()
	return t.Format("2006-01-02 15:04:05")
}
