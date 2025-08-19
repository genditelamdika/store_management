package postgres 

import (
	"fmt"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func DatabaseInit() {
	var err error
	dsn := "host=localhost user=postgres password=1234 dbname=store_management port=5432 sslmode=disable TimeZone=Asia/Jakarta"

	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err)
	}

	fmt.Println("Connected to PostgreSQL Database")
}
