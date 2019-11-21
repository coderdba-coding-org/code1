package main

import (
	//"crypto/tls"
	//"encoding/base64"
	//"encoding/json"
	"flag"
	//"fmt"
	//"www.github.com/coderdba-coding-org/func1/app"
	//"www.github.com/coderdba-coding-org/func1/app/logger"
	//"io/ioutil"
	"log"
        "app"
	//"net"
	//"net/http"
	"os"
	//"os/exec"
	"path"
	//"strings"
)

const KEY_FILE_NAME  = "myapprsakey.pem"
const CERT_FILE_NAME = "myapprsacert.pem"
//const certDir = "/etc/kubernetes/pki"
const certDir = "/tmp"

func main() {

	log.Println("Starting main program to create cert")

        // Set default vaules for command line arguments

        // UNCOMMENT THEM WHEN REQUIRED - OTHERWISE COMPILER ERRORS IF THEY ARE NOT USED LATER ON
	//varOU       := flag.String("OU", "MT", "Org Unit for the certificate")
	//varLbIP     := flag.String("IP", "", "IP of the Load Balancer")
	//varHostIP   := flag.String("IP", "", "IP for the host")
        //varHostName := flag.String("HOSTNAME", "", "Hostname")
        //varHostFQDN := flag.String("FQDN", "", "FQDN of the host")
        varLbFQDN   := flag.String("LB_FQDN", "", "FQDN of the load balancer")
	//varAltSAN   := flag.String("ALT_SAN", "https://*.mycompany.com", "SAN/Subject Alternative Name for certificate")

        // Get vaules of command line arguments
        flag.Parse()

        // Log error if any argument is missing
        // JUST ONE SAMPLE - do the same for others
       	if *varLbFQDN == "" {
		log.Fatalf("Empty value for LB_FQDN")
	} 


        // Check if cert and key files exist - throw warning and exit if they already exist
        certPath := path.Join(certDir, CERT_FILE_NAME)
        keyPath  := path.Join(certDir, KEY_FILE_NAME)
        certExists := false
        keyExists  := false

        if _, err := os.Stat(certPath); os.IsNotExist(err) {
		certExists = false
		log.Printf("Certficate file %s %s does not exist in the machine", certPath, certExists)
	}

        if _, err := os.Stat(keyPath); os.IsNotExist(err) {
		keyExists = false
		log.Printf("Key file %s %s does not exist in the machine", keyPath, keyExists)
	}


        // Get the URLs for the hostname
        urls, err := app.CreateURLs ("host1.company.com")

        log.Printf("Error %s", err)
        log.Printf("Metrics URL is %s", urls.MetricsURL)
        log.Printf("Health URL is %s", urls.HealthURL)

        // Get a processor from the processor.go program in the app package (which is in app subfolder)
        //processor := app.Processor{}
}
