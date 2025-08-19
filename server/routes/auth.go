package routes

import (
	"store_management/handlers"
	"store_management/pkg/postgres"
	"store_management/repositories"

	"github.com/gin-gonic/gin"
)

func AuthRoutes(r *gin.RouterGroup) {
	// Inisialisasi repository dan handler
	authRepository := repositories.RepositoryAuth(postgres.DB)
	h := handlers.HandlerAuth(authRepository)
	r.POST("/login", h.Login)
}
