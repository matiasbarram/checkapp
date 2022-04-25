package utils

import (
	"errors"
	"fmt"
	"strconv"
	"strings"

	geo "github.com/kellydunn/golang-geo"
)

func getCoordinates(location string) (float64, float64, error) {
	var x float64
	var y float64
	coord := strings.Split(strings.ReplaceAll(location, " ", ""), ",")
	if len(coord) != 2 {
		return x, y, errors.New("Invalid location: " + location)
	}
	x, err := strconv.ParseFloat(coord[0], 64)
	if err != nil {
		return x, y, err
	}
	y, err = strconv.ParseFloat(coord[1], 64)
	if err != nil {
		return x, y, err
	}
	return x, y, nil
}

func CalculateDistance(user_location string, company_location string) (float64, error) {
	var dist float64
	ux, uy, err := getCoordinates(user_location)
	if err != nil {
		return dist, errors.New(fmt.Sprint(7))
	}
	cx, cy, err := getCoordinates(company_location)
	if err != nil {
		return dist, errors.New(fmt.Sprint(8))
	}
	up := geo.NewPoint(ux, uy)
	cp := geo.NewPoint(cx, cy)

	// find the great circle distance between them
	dist = up.GreatCircleDistance(cp)
	return dist, nil
}
