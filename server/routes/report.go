package routes

import (
	"store_management/handlers"
	"store_management/pkg/postgres"
	"store_management/repositories"

	"github.com/gin-gonic/gin"
)

func ReportRoutes(r *gin.RouterGroup) {
	// Inisialisasi repository dan handler
	reportRepository := repositories.RepositoryReport(postgres.DB)
	h := handlers.NewReportHandler(reportRepository)

	// Routes
	r.POST("/report/:context", h.CreateReport)
	// r.GET("/report/store/:store_id", h.GetReportsByStore)


}
