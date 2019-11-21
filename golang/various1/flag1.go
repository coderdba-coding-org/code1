package main

import (
	"fmt"
	"flag"
	"regexp"
)

func main() {

//var ip = flag.Int("flagname", 1234, "help message for flagname")
subjectAltName := flag.String("SUBJECT_ALT_NAME", "*.strapi.company.com", "wildcard fqdn")

r, _ := regexp.Compile("\\.company\\.com")
subjectTemplate1 := r.ReplaceAllString("node1.company.com", "%s.company.com")
subjectTemplate2 := r.ReplaceAllString(*subjectAltName, "%s.company.com")
fmt.Println(subjectTemplate1)
fmt.Println(subjectTemplate2)

}
