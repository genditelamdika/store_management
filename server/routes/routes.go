package routes

import (
    "github.com/gin-gonic/gin"
)

func RouteInit(r *gin.Engine) {
    // Grouping API versi /api
    api := r.Group("/api/v1")
    
    AuthRoutes(api)
	ReportRoutes(api)
}
