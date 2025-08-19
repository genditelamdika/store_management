package models
import "time"

type Promo struct {
	ID        uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	PromoName string    `gorm:"type:varchar(255);not null" json:"promo_name"`
	Active    bool      `gorm:"not null" json:"active"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

type PromoReport struct {
    ID        uint      `gorm:"primaryKey" json:"id"`
    StoreID   uint      `gorm:"not null" json:"store_id"`
    ProductID uint      `gorm:"not null" json:"product_id"`
    PromoName string    `gorm:"type:varchar(255)" json:"promo_name"`
    NormalPrice float64 `gorm:"not null" json:"normal_price"`
    PromoPrice  float64 `gorm:"not null" json:"promo_price"`
    Date      time.Time `gorm:"not null" json:"date"`
}
