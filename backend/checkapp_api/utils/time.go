package utils

import (
	"fmt"
	"math"
	"strings"
	"time"

	. "github.com/WAY29/icecream-go/icecream"
)

func GetTimeDiffSeconds(timeA string, isArrival bool) (float64, error) {
	t, err := time.Parse(time.RFC3339, strings.Replace(timeA, " ", "T", 1)+"-04:00")
	if err != nil {
		Ic(timeA)
		return 0, err
	}
	now := time.Now()
	var diff time.Duration
	if isArrival {
		diff = now.Sub(t)

	} else {
		diff = t.Sub(now)
	}
	return diff.Seconds(), nil
}

func FormatSecondsToHHMMSS(seconds float64) (string, error) {

	hours := math.Floor(seconds / 60 / 60)
	minutes := math.Floor(seconds / 60)
	remainderSeconds = seconds % 60
	formatedSeconds, err := fmt.Printf("%02d:%02d:%02d", hours, minutes, remainderSeconds)

}
