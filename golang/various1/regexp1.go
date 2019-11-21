package main

import (
	"fmt"
	"regexp"
)

func main() {

r, _ := regexp.Compile("\\.company\\.com")

subjectTemplate1 := r.ReplaceAllString("node1.company.com", "%s.company.com")

fmt.Println(subjectTemplate1)

}
