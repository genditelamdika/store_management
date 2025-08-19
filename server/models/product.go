package models

import (
    "time"

    "gorm.io/datatypes" 
)

type Product struct {
	ID      uint   `gorm:"primaryKey" json:"id"`
	Name    string `gorm:"type:varchar(255)" json:"name"`
	Barcode string `gorm:"type:varchar(50)" json:"barcode"`
	Volume  string `gorm:"type:varchar(50)" json:"volume"`
}

type ProductReport struct {
	ID      uint `gorm:"primaryKey" json:"id"`
	StoreID uint `gorm:"not null" json:"store_id"`
	// ProductID uint      `gorm:"not null" json:"product_id"`
	Products datatypes.JSON `gorm:"type:jsonb" json:"products"`
	Date      time.Time       `gorm:"not null" json:"date"`
}
type NameProductReport struct {
    ProductID int  `json:"product_id"`
    Available bool `json:"available"`
}
