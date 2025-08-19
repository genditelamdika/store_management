package repositories

import (
	"store_management/models"

	"gorm.io/gorm"
)

type ReportRepository interface {
	CreateAttendance(report models.Attendance) (models.Attendance, error)
	CreateProductReport(report models.ProductReport) (models.ProductReport, error)
	CreatePromoReport(report models.PromoReport) (models.PromoReport, error)
	 GetProductReportsByStore(storeID uint) ([]models.ProductReport, error)
}

type reportRepository struct {
	db *gorm.DB
}

// RepositoryReport membuat instance repository baru
func RepositoryReport(db *gorm.DB) ReportRepository {
	return &reportRepository{db}
}

func (r *reportRepository) CreateAttendance(report models.Attendance) (models.Attendance, error) {
	err := r.db.Create(&report).Error
	return report, err
}

func (r *reportRepository) CreateProductReport(report models.ProductReport) (models.ProductReport, error) {
	err := r.db.Create(&report).Error
	return report, err
}

func (r *reportRepository) CreatePromoReport(report models.PromoReport) (models.PromoReport, error) {
	err := r.db.Create(&report).Error
	return report, err
}

func (r *reportRepository) GetProductReportsByStore(storeID uint) ([]models.ProductReport, error) {
    var reports []models.ProductReport
    err := r.db.Where("store_id = ?", storeID).Find(&reports).Error
    return reports, err
}
