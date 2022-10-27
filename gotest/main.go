package main

import (
	"flag"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

var version = flag.String("v", "v1", "v1")

func main() {
	gin.SetMode(gin.ReleaseMode)
	router := gin.Default()

	router.GET("", func(c *gin.Context) {
		flag.Parse()
		hostname, _ := os.Hostname()

		c.String(http.StatusOK, "[%d]This is version:%s running in pod %s", time.Now().UnixMilli(), *version, hostname)
	})

	router.Run(":8080")
}
