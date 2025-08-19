
package models

type Store struct {
	ID      uint   `gorm:"primaryKey" json:"id"`
	Name    string `gorm:"type:varchar(255)" json:"name"`
	Code    string `gorm:"type:varchar(255)" json:"code"`
	Address string `gorm:"type:varchar(255)" json:"address"`
}
