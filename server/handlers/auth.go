package handlers

import (
	"fmt"
	"log"
	"net/http"
	authdto "store_management/dto/auth"
	dto "store_management/dto/result"
	"time"

	"store_management/models"
	"store_management/pkg/bcrypt"
	jwtToken "store_management/pkg/jwt"
	"store_management/repositories"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/golang-jwt/jwt/v4"
)

type handlerAuth struct {
	AuthRepository repositories.AuthRepository
}

func HandlerAuth(AuthRepository repositories.AuthRepository) *handlerAuth {
	return &handlerAuth{AuthRepository}
}

// Register
func (h *handlerAuth) Register(c *gin.Context) {
	var request authdto.AuthRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResult{Code: http.StatusBadRequest, Message: err.Error()})
		return
	}

	validation := validator.New()
	if err := validation.Struct(request); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResult{Code: http.StatusBadRequest, Message: err.Error()})
		return
	}

	password, err := bcrypt.HashingPassword(request.Password)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResult{Code: http.StatusBadRequest, Message: err.Error()})
		return
	}

	user := models.User{
		Fullname: request.Fullname,
		Email:    request.Email,
		Password: password,
	}

	data, err := h.AuthRepository.Register(user)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResult{Code: http.StatusInternalServerError, Message: err.Error()})
		return
	}

	claims := jwt.MapClaims{
		"id":  data.ID,
		"exp": time.Now().Add(time.Hour * 2).Unix(),
	}

	token, errGenerateToken := jwtToken.GenerateToken(&claims)
	if errGenerateToken != nil {
		log.Println(errGenerateToken)
		c.JSON(http.StatusUnauthorized, dto.ErrorResult{Code: http.StatusUnauthorized, Message: "Unauthorized"})
		return
	}

	registerResponse := authdto.AuthResponse{
		Email: user.Email,
		Token: token,
	}

	c.JSON(http.StatusOK, dto.SuccessResult{Code: http.StatusOK, Data: registerResponse})
}

// Login
func (h *handlerAuth) Login(c *gin.Context) {
	var request authdto.LoginRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResult{Code: http.StatusBadRequest, Message: err.Error()})
		return
	}

	user, err := h.AuthRepository.Login(request.Fullname)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResult{Code: http.StatusBadRequest, Message: "wrong email or password"})
		return
	}

	if !bcrypt.CheckPasswordHash(request.Password, user.Password) {
		c.JSON(http.StatusBadRequest, dto.ErrorResult{Code: http.StatusBadRequest, Message: "wrong email or password"})
		return
	}

	claims := jwt.MapClaims{
		"id":  user.ID,
		"exp": time.Now().Add(time.Hour * 2).Unix(),
	}

	token, errGenerateToken := jwtToken.GenerateToken(&claims)
	if errGenerateToken != nil {
		log.Println(errGenerateToken)
		c.JSON(http.StatusUnauthorized, dto.ErrorResult{Code: http.StatusUnauthorized, Message: "Unauthorized"})
		return
	}
	stores, _ := h.AuthRepository.GetStores()
	products, _ := h.AuthRepository.GetProducts()

	// 🔹 Convert ke DTO
	var productInfos []authdto.ProductInfo
	for _, p := range products {
		productInfos = append(productInfos, authdto.ProductInfo{
			ID:      int(p.ID),
			Name:    p.Name,
			Barcode: p.Barcode,
			Volume:  p.Volume,
		})
	}
	var storeInfos []authdto.StoreInfo
	for _, s := range stores {
		storeInfos = append(storeInfos, authdto.StoreInfo{
			ID:      int(s.ID),
			Name:    s.Name,
			Code:    s.Code,
			Address: s.Address,
		})
	}

	loginResponse := authdto.LoginResponse{
		Token: token,
		User: authdto.UserInfo{
			ID:       user.ID,
			Username: user.Fullname,
		},
		Stores:   storeInfos,
		Products: productInfos,
		
	}
	fmt.Printf("%+v\n", products)


	c.JSON(http.StatusOK, dto.SuccessResult{Code: http.StatusOK, Data: loginResponse,Message: "Login successful"})
}

