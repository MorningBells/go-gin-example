# https://docs.docker.com/language/golang/build-images/
# 基础映像
FROM golang:latest as build
# GO111MODULE是Go 1.11中的新功能，它允许您在GOPATH之外构建Go代码。配合使用GO111MODULE=on和go mod init命令，可以在GOPATH之外构建Go代码。
ENV GO111MODULE on
# GOPROXY是代理，用于加速Go模块的下载
ENV GOPROXY https://goproxy.cn,direct
# 指示 Docker 使用此目录作为所有后续命令的默认目标。这样我们就不必输入完整的文件路径，而是可以使用基于该目录的相对路径。
WORKDIR /go/release
# 安装编译它所必需的模块前，需要将 go.mod和go.sum文件复制到其中。ADD或者COPY
# go.mod是Go模块的依赖文件，go.sum是Go模块的依赖校验文件
ADD go.mod .
ADD go.sum .
#  将Go模块安装到定义的目录中
# go mod download命令会根据go.mod文件中的依赖关系，下载所有依赖包到本地的GOPATH/pkg/mod目录中
RUN go mod download
# 将当前目录下的所有文件复制到工作目录中
ADD . .
# 声明服务运行在8010端口
EXPOSE 8010
# 指定维护者的名字
MAINTAINER wangyi

# 编译程序, -ldflags="-s -w"可以用来减少体积，-s的作用是去掉符号表，在程序panic的时候stack trace就没有任何文件名/行号信息了，-w的作用是去掉DWARF调试信息，而后得到的程序就不能用gdb调试了
# 交叉编译， 在一个linux系统上编译出windows的可执行文件。
# GOOS是目标平台的操作系统（darwin、freebsd、linux、windows） GOARCH是目标平台的体系架构（386、amd64、arm） go build -o main.exe -ldflags="-s -w" -v -a -tags netgo -installsuffix netgo -gcflags "-N -l" -o main.exe
# ldflags是链接器参数，-s是去掉符号表，-w是去掉DWARF调试信息
# CGO_ENABLED是用来控制是否使用cgo编译，默认是1，也就是使用cgo编译，如果设置为0，就是不使用cgo编译
# cgo是go语言的一个扩展，允许go语言调用C代码，go语言本身是不支持C语言的，但是cgo可以让go语言调用C语言的库，比如调用openssl库，或者调用系统的库
# installsuffix是为了解决不同平台编译出来的包名字相同的问题，比如在linux和windows上编译出来的包名字都是main，这样就会冲突，所以在linux上编译出来的包名字是main_linux，windows上编译出来的包名字是main_windows
# installsuffix用法：go build -o main -ldflags="-s -w" -v -a -tags netgo -installsuffix netgo -gcflags "-N -l" -o main
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o blog main.go

# scratch是一个空的镜像，用来存放我们的二进制文件
FROM scratch as prod
# COPY是将上一阶段的二进制文件复制到当前阶段的镜像中
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY --from=build /go/release/blog /
COPY --from=build /go/release/conf ./conf

# CMD命令用来指定容器启动时要运行的命令，这里是运行我们编译好的二进制文件
CMD ["/blog"]


# go build是编译
# go install是编译并安装到$GOPATH/bin目录下
# go run是编译并运行
# go test是测试
# go fmt是格式化代码
# go get是下载第三方包
# go mod是go module的命令
# go env是查看go的环境变量
# go doc是查看go的文档
# go list是查看go的包列表
# go vet是检查代码
# go clean是清除编译的文件
# go tool是go的工具
# go version是查看go的版本



# testing框架用法，测试用例文件名必须以_test.go结尾，测试用例函数必须以Test开头，测试用例函数必须接受一个*testing.T类型的参数，测试用例函数必须在同一个包中。
# 基准测试用例文件名必须以_test.go结尾，基准测试用例函数必须以Benchmark开头，基准测试用例函数必须接受一个*testing.B类型的参数，基准测试用例函数必须在同一个包中。
# 基准测试是测试函数的性能，基准测试函数会执行b.N次，然后计算平均值，b.N的值是不断增加的，直到测试时间超过1秒，所以基准测试函数的执行时间不能太短，否则b.N的值会很小，测试结果不准确。

# 覆盖率测试用例文件名必须以_test.go结尾，覆盖率测试用例函数必须以Example开头，覆盖率测试用例函数必须在同一个包中。
# 覆盖率测试是测试函数的覆盖率，覆盖率测试函数会执行，然后计算平均值，b.N的值是不断增加的，直到测试时间超过1秒，所以基准测试函数的执行时间不能太短，否则b.N的值会很小，测试结果不准确。

# go test -v -coverprofile=coverage.out -covermode=atomic



# go性能分析工具，go tool pprof是go自带的性能分析工具，go tool pprof可以分析CPU、内存、阻塞、互斥锁等。
# Graphviz是一个开源的图形可视化工具，可以将go tool pprof生成的图形文件转换成图片。