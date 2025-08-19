package repositories

import (
	"store_management/models"

	"gorm.io/gorm"
)

// AuthRepository adalah interface untuk operasi autentikasi
type AuthRepository interface {
	Register(user models.User) (models.User, error)
	Login(email string) (models.User, error)
	GetStores() ([]models.Store, error)
    GetProducts() ([]models.Product, error)
}

// repository adalah implementasi dari AuthRepository
type repository struct {
	db *gorm.DB
}

// RepositoryAuth membuat instance baru repository Auth
func RepositoryAuth(db *gorm.DB) AuthRepository {
	return &repository{db}
}

// Register menambahkan user baru ke database
func (r *repository) Register(user models.User) (models.User, error) {
	err := r.db.Create(&user).Error
	return user, err
}

// Login mencari user berdasarkan email
func (r *repository) Login(fullname string) (models.User, error) {
	var user models.User
	err := r.db.First(&user, "fullname = ?", fullname).Error
	return user, err
}
func (r *repository) GetStores() ([]models.Store, error) {
    var stores []models.Store
    err := r.db.Find(&stores).Error
    return stores, err
}

func (r *repository) GetProducts() ([]models.Product, error) {
    var products []models.Product
    err := r.db.Find(&products).Error
    return products, err
}
