package database

import (
	"fmt"
	"store_management/models"
	"store_management/pkg/postgres"
)

func RunMigration() {
	err := postgres.DB.AutoMigrate(
		&models.User{},
		&models.Attendance{},
		&models.Product{},
		&models.Promo{},
		&models.Store{},
		&models.ProductReport{},
        &models.PromoReport{},
	)

	if err != nil {
		fmt.Println(err)
		panic("Migration Failed")
	}

	fmt.Println("Migration Success")
}