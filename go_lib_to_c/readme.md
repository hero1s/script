
* 安装依赖：
  * go install -buildmode=shared -linkshared std
* 编译：
  * go build -buildmode=c-shared -o libtest.so main.go
  * go build -buildmode=c-archive -o libtest.a main.go
* 使用：
  * gcc ./test.c -o testgo -L ./ -ltest

* 注意：
  * //export funA 注释必须写,并且//后面不要有空格