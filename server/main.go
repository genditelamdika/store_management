package main

import (
	"fmt"
	"log"
	"store_management/database"
	"store_management/pkg/postgres"
	"store_management/routes"
	"store_management/seed"

	"github.com/gin-gonic/gin"
)

func main() {
	postgres.DatabaseInit()

	database.RunMigration()
	seed.SeedData(postgres.DB)
	

	r := gin.Default()

	routes.RouteInit(r)
	fmt.Println("server running localhost:5000")
	if err := r.Run("localhost:5000"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
