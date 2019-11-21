package app

import (
	//"crypto/x509"
	//"encoding/pem"
	//"fmt"
	//"github.com/jpillora/backoff"
	//"io/ioutil"
	"log"
	//"os"
	"regexp"
	//"time"
)

type Processor struct {
	Settings string
}

// Note: Variables that start with capitals in strucxt can be accessed from outside of this package also
type Urls struct {
        HealthURL string
        MetricsURL string
}

func CreateURLs (hostName string) (urls Urls, err error) {

        r, _ := regexp.Compile("\\.company\\.com")

        healthURL  := r.ReplaceAllString(hostName, ".company.com/health")
        metricsURL := r.ReplaceAllString(hostName, ".company.com/metrics")

        log.Printf("In CreateURLs: Metrics URL is %s", metricsURL)
        log.Printf("In CreateURLs: Health URL is %s", healthURL)

	urls = Urls{
                     HealthURL:   healthURL,
                     MetricsURL:  metricsURL,
	}

	return urls, nil
}
