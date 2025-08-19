package authdto


type LoginResponse struct {
	Token    string        `json:"token"`
	User     UserInfo      `json:"user"`
	Stores   []StoreInfo   `json:"stores"`
	Products []ProductInfo `json:"products"`
}

type UserInfo struct {
	ID       int    `json:"id"`
	Username string `json:"username"`
}

type StoreInfo struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	Code    string `json:"code"`
	Address string `json:"address"`
}

type ProductInfo struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	Barcode string `json:"barcode"`
	Volume  string `json:"volume"`
}


type AuthResponse struct {
	Email string `gorm:"type: varchar(255)" json:"email"`
	Token string `gorm:"type: varchar(255)" json:"token"`
}