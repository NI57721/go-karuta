package main

import (
	"net/http"
	"strconv"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

var counter = 0

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.GET("/", hello)
	e.Logger.Fatal(e.Start("0.0.0.0:8080"))
}

func hello(c echo.Context) error {
	counter++
	return c.String(http.StatusOK, "Hello from echo! #"+strconv.Itoa(counter))
}
