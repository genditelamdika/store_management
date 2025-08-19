package models
import "time"
type Attendance struct {
	ID        uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	UserID    uint      `gorm:"not null" json:"user_id"`
	Status   string    `gorm:"type:varchar(50)" json:"status"`
	CreatedAt time.Time
	UpdatedAt time.Time
}
