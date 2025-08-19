package seed

import (
	"log"
	"store_management/models"
	"store_management/pkg/bcrypt"

	"gorm.io/gorm"
)

func SeedData(db *gorm.DB) {
	stores := []models.Store{
		{Name: "TOKO INDOJUNI", Code: "INDO", Address: "Jl. Kembangan Raya No.2, Jakarta Barat 11610"},
		{Name: "TOKO TINTIN", Code: "TNTN", Address: "JDr. Sumarno No.1, Pulo Gebang, Kec. Cakung, Kota Jakarta Timur"},
		{Name: "TOKO WARASANGIT", Code: "WRSG", Address: "Jl. Yos Sudarso No.27-29 19, RT.19/RW.5, Kb. Bawang, Kec. Tj. Priok, Jkt Utara"},
	}

	products := []models.Product{
		{Name: "Keripik Kentang Xie-xie", Barcode: "XIE250", Volume: "250mL"},
		{Name: "Biskuit Kelapa Ni-hao", Barcode: "NIH100", Volume: "100mL"},
		{Name: "Coklat Kacang Peng-you", Barcode: "PNG050", Volume: "50mL"},
	}
	db.Create(&products)

	db.Create(&stores)
	seedAdminUser(db)
}

func seedAdminUser(db *gorm.DB) {
	adminEmail := "fajar@example.com"

	var user models.User
	err := db.First(&user, "email = ?", adminEmail).Error
	if err == gorm.ErrRecordNotFound {
		password, _ := bcrypt.HashingPassword("123456")

		admin := models.User{
			Fullname: "fajar",
			Email:    adminEmail,
			Password: password,
		}

		if err := db.Create(&admin).Error; err != nil {
			log.Println(" Gagal buat user admin:", err)
		} else {
			log.Println("User admin berhasil dibuat (email: admin@example.com, password: admin123)")
		}
	} else {
		log.Println("user admin sudah ada, skip seeding")
	}
}
