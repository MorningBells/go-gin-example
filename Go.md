## Go命令行工具汇总

### 1. go build
`go build是编译，计算文件的依赖关系，编译源码文件、代码包以及依赖的代码包，生成可执行文件。`
* go build无参构造：`go build`，默认构建当前目录下的main包，生成可执行文件，文件名为当前目录名。
* go build指定文件：`go build main.go`，构建指定文件，生成可执行文件，文件名为main。
* go build指定目录：`go build ./`，构建指定目录下的main包，生成可执行文件，文件名为当前目录名。
* go build缩小可执行文件的体积。`go build -ldflags "-s -w"`，去掉符号表和调试信息，缩小可执行文件的体积。-s去掉符号表，在程序panic的时候stack trace就没有任何文件名/行号信息了，-w的作用是去掉DWARF调试信息，而后得到的程序就不能用gdb调试了
    * stack trace是指程序在运行时，当发生异常时，程序会打印出当前的调用栈信息，这个信息就叫做stack trace。
    * DWARF是一种调试信息格式，它是一种标准的调试信息格式，它的全称是Debugging With Arbitrary Record Formats，意思是用任意的记录格式来调试。
    * gdb调试是指在程序运行时，可以通过gdb命令来查看程序的运行状态，比如查看程序的变量值，查看程序的调用栈等等。
    ```
    RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o blog main.go
  ```
### 2.go install
`go install是编译并安装，将编译出来的可执行文件放到$GOPATH/bin目录下，将编译的中间件放到pkg目录下`
* 使用go install -n查看运行过程中该命令做了什么事情，不执行
* 使用go install -v查看编译过程中的详细信息
* 使用go install -x查看编译过程中的详细信息，包括编译器的参数
* 使用go install -a强制重新编译所有的包
* 使用go install -i强制重新安装所有的包
* 使用go install -work查看编译过程中的临时文件
* 使用go install -race编译带有race检测的程序
* 使用go install -msan编译带有msan检测的程序
* race检测是指在程序运行时，检测程序中是否存在数据竞争的问题，如果存在数据竞争的问题，程序会报错。
* msan检测是指在程序运行时，检测程序中是否存在内存泄漏的问题，如果存在内存泄漏的问题，程序会报错。
* 交叉编译，在一个平台生成另外一个平台的可执行文件。`GOOS=linux GOARCH=amd64 go install`，在windows平台生成linux平台的可执行文件。
* GOOS是指目标平台的操作系统（darwin、freebsd、linux、windows）。
* GOARCH是指目标平台的体系架构（386、amd64、arm）。
* CGO_ENABLED=0是指禁用cgo，因为交叉编译时，cgo是不支持的。
### 3.go run
`go run是编译并运行。对象只能是单个或者多个.go文件，且不能为测试文件`
* 无法针对包运行go run，只能使用go build编译整个包，再运行编译后的可执行文件。
* 使用go run -work 可以显示当前的编译目录。
* 使用go run -x 可以显示编译过程中的命令。
* 使用go run -gcflags "-m" 可以显示编译过程中的内存分配情况。
* 使用go run -gcflags "-m -m" 可以显示编译过程中的内存分配情况和内存分配的位置。
* 使用go run -gcflags "-m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因。
* 使用go run -gcflags "-m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型。
* 使用go run -gcflags "-m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小。
* 使用go run -gcflags "-m -m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小和内存分配的函数。
* 使用go run -gcflags "-m -m -m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小和内存分配的函数和内存分配的行号。
* 使用go run -gcflags "-m -m -m -m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小和内存分配的函数和内存分配的行号和内存分配的堆栈。
* 使用go run -gcflags "-m -m -m -m -m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小和内存分配的函数和内存分配的行号和内存分配的堆栈和内存分配的堆栈的位置。
* 使用go run -gcflags "-m -m -m -m -m -m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小和内存分配的函数和内存分配的行号和内存分配的堆栈和内存分配的堆栈的位置和内存分配的堆栈的函数。
* 使用go run -gcflags "-m -m -m -m -m -m -m -m -m -m -m" 可以显示编译过程中的内存分配情况和内存分配的位置和内存分配的原因和内存分配的类型和内存分配的大小和内存分配的函数和内存分配的行号和内存分配的堆栈和内存分配的堆栈的位置和内存分配的堆栈的函数和内存分配的堆栈的行号。
### 4.go test
`go test是测试，测试文件有固定结构以_test.go结尾`
* 单元测试，导入测试框架testing。
  * testing是go语言自带的测试框架，可以用来测试函数，方法，接口，结构体等等。
  * testing框架用法，测试用例文件名必须以_test.go结尾，测试用例函数必须以Test开头，测试用例函数必须接受一个*testing.T类型的参数，测试用例函数必须在同一个包中。
  * 测试用例函数中，可以使用t.Log()记录日志，使用t.Fail()或t.FailNow()标记测试失败，使用t.Fatal()或t.FatalNow()标记测试失败并终止测试。
  * 测试用例函数中，可以使用t.Run()运行子测试用例，子测试用例函数必须以Test开头，子测试用例函数必须接受一个*testing.T类型的参数，子测试用例函数必须在同一个包中。
  * 测试用例函数中，可以使用t.Parallel()标记测试用例函数可以并行执行。
  * 测试用例函数中，可以使用t.Skip()或t.SkipNow()跳过测试用例函数。
  * 测试用例函数中，可以使用t.Helper()标记测试用例函数是辅助函数。
  * 测试用例函数中，可以使用t.Cleanup()注册清理函数。
  * 子测试用例是测试用例的一部分，子测试用例可以并行执行，子测试用例可以跳过，子测试用例可以注册清理函数。
  * 辅助函数是测试用例的一部分，辅助函数可以并行执行，辅助函数可以跳过，辅助函数可以注册清理函数。
* 基准测试
  * 基准测试是测试函数的性能，基准测试函数会执行b.N次，然后计算平均值，b.N的值是不断增加的，直到测试时间超过1秒，所以基准测试函数的执行时间不能太短，否则b.N的值会很小，测试结果不准确。
  * 基准测试函数必须以Benchmark开头，基准测试函数必须接受一个*testing.B类型的参数，基准测试函数必须在同一个包中。
* 覆盖率测试
  * 覆盖率测试用于统计通过程序包的测试用例覆盖了多少代码
  * `go test -coverprofile=cover.out`生成覆盖率测试报告
    * `go tool cover -html=cover.out`查看覆盖率测试报告
  * `go test -coverprofile=cover.out -covermode=count`生成覆盖率测试报告，统计每个代码块被执行的次数
    * `go tool cover -html=cover.out -o cover.html`查看覆盖率测试报告
  * `go test -coverprofile=cover.out -covermode=atomic`生成覆盖率测试报告，统计每个代码块被执行的次数，使用原子操作
    * `go tool cover -html=cover.out -o cover.html`查看覆盖率测试报告
  * `go test -coverprofile=cover.out -covermode=set`生成覆盖率测试报告，统计每个代码块被执行的次数，使用集合
    * `go tool cover -html=cover.out -o cover.html`查看覆盖率测试报告
  * `go test -coverprofile=cover.out -covermode=atomic -coverpkg=github.com/astaxie/beego,github.com/astaxie/beego/context`生成覆盖率测试报告，统计每个代码块被执行的次数，使用原子操作，只统计github.com/astaxie/beego和github.com/astaxie/beego/context包的代码覆盖率
    * `go tool cover -html=cover.out -o cover.html`查看覆盖率测试报告
  * `go test -coverprofile=cover.out -covermode=atomic -coverpkg=./...`生成覆盖率测试报告，统计每个代码块被执行的次数，使用原子操作，只统计当前包及其子包的代码覆盖率
    * `go tool cover -html=cover.out -o cover.html`查看覆盖率测试报告
  * `go test -coverprofile=cover.out -covermode=atomic -coverpkg=.`生成覆盖率测试报告，统计每个代码块被执行的次数，使用原子操作，只统计当前包的代码覆盖率
    * `go tool cover -html=cover.out -o cover.html`查看覆盖率测试报告
  
### 5.go fmt
`go fmt是格式化代码，go fmt会自动格式化代码，使代码更加美观，更加易读。`
* 如果传入具体文件路径，会格式化该文件
* 如果传入目录路径，会格式化该目录下的所有文件
* 如果不传入参数，会格式化当前目录下的所有文件
### 6.go get
`go get是下载第三方包。把第三方包下载到GOPATH/src目录下。`
* 很多go的三方包被托管到github上，所以我们可以直接使用go get github.com/xxx/xxx来下载。包的路径是有规范的，一般是github.com/用户名/项目名。
* 使用go get -u github.com/xxx/xxx可以更新包。
* 使用go get -n github.com/xxx/xxx可以查看go get命令执行的过程。
### 7.go doc
`go doc是查看go的文档`
* 使用go doc fmt可以查看fmt包的文档
* 使用go doc fmt Println可以查看fmt包中的Println函数的文档
* 使用go doc -http=:6060可以在本地启动一个web服务，通过浏览器访问http://localhost:6060可以查看go的文档
### 8.go tool
`go tool是使用go的工具`
* 使用go tool compile可以编译go的源代码
* 使用go tool link可以链接go的源代码
* 使用go tool asm可以汇编go的源代码
* 使用go tool cgo可以使用cgo
* 使用go tool dist可以查看go的分布式编译
* 使用go tool fix可以修复go的代码
* 使用go tool nm可以查看go的符号表
* 使用go tool objdump可以查看go的目标文件
* 使用go tool pack可以打包go的目标文件
* 使用go tool pprof可以查看go的性能分析
  * `go tool pprof -http=:6060 cpu.prof`可以在本地启动一个web服务，通过浏览器访问http://localhost:6060可以查看go的性能分析
  * Graphviz是一个图形绘制工具，可以用来绘制结构化的图形网络，支持多种格式输出
* 使用go tool trace可以查看go的跟踪
* 使用go tool yacc可以使用yacc
* 使用go tool vet可以查看go的vet
* 使用go tool dist list可以查看go的分布式编译列表
* 使用go tool dist test可以测试go的分布式编译
* 使用go tool dist install可以安装go的分布式编译
* 使用go tool dist clean可以清除go的分布式编译
* 使用go tool dist env可以查看go的分布式编译环境变量
* 使用go tool dist test -no-rebuild可以测试go的分布式编译，不重新编译
### 9.其他命令
* go version是查看go的版本
* go list是查看go的包列表
* go vet是检查代码
* go clean是清除编译的文件
* go mod是go module的命令
* go env是查看go的环境变量

