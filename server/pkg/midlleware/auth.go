package midlleware

import (
	dto "store_management/dto/result"
	jwtToken "store_management/pkg/jwt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)
type Result struct {
	Code    int         `json:"code"`
	Data    interface{} `json:"data"`
	Message string      `json:"message"`
}

func Auth() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")

		if token == "" {
			c.JSON(http.StatusUnauthorized, dto.ErrorResult{
				Code:    http.StatusBadRequest,
				Message: "unauthorized",
			})
			c.Abort() 
			return
		}

		// Format: Bearer <token>
		parts := strings.Split(token, " ")
		if len(parts) != 2 {
			c.JSON(http.StatusUnauthorized, Result{
				Code:    http.StatusUnauthorized,
				Message: "invalid token format",
			})
			c.Abort()
			return
		}

		claims, err := jwtToken.DecodeToken(parts[1])
		if err != nil {
			c.JSON(http.StatusUnauthorized, Result{
				Code:    http.StatusUnauthorized,
				Message: "unauthorized",
			})
			c.Abort()
			return
		}
		c.Set("userLogin", claims)

		c.Next()
	}
}
