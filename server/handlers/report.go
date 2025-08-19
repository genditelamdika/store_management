package handlers

import (
	"net/http"
	"store_management/models"
	"store_management/repositories"
	"strconv"

	"github.com/gin-gonic/gin"
)

type ReportHandler struct {
	ReportRepo repositories.ReportRepository
}

func NewReportHandler(reportRepo repositories.ReportRepository) *ReportHandler {
	return &ReportHandler{ReportRepo: reportRepo}
}

func (h *ReportHandler) CreateReport(c *gin.Context) {
	context := c.Param("context") 

	switch context {
	case "attendance":
		var req models.Attendance
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		report, err := h.ReportRepo.CreateAttendance(req)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, report)

	case "product":
		var req models.ProductReport 
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		report, err := h.ReportRepo.CreateProductReport(req)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, report)

	case "promo":
		var req models.PromoReport
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		report, err := h.ReportRepo.CreatePromoReport(req)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, report)

	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Unknown report context"})
	}
	
}
func (h *ReportHandler) GetReportsByStore(c *gin.Context) {
    storeIDStr := c.Param("store_id")
    storeID, err := strconv.Atoi(storeIDStr)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid store_id"})
        return
    }

    reports, err := h.ReportRepo.GetProductReportsByStore(uint(storeID))
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, reports)
}
