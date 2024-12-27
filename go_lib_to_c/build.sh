#!/bin/bash
#set -xe

#go build -buildmode=c-shared -o ./lib/libtest.so main.go
go build -buildmode=c-archive -o ./lib/libtest.a main.go

