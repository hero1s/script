package main

import "C"

//export goFunc
func goFunc(a, b int) int {
	return a + b
}

func main() {

}
