# https://docs.docker.com/language/golang/build-images/
# 基础映像
FROM golang:latest as build
ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn,direct
# 指示 Docker 使用此目录作为所有后续命令的默认目标。这样我们就不必输入完整的文件路径，而是可以使用基于该目录的相对路径。
WORKDIR /go/release
# 安装编译它所必需的模块前，需要将 go.mod和go.sum文件复制到其中。ADD或者COPY
ADD go.mod .
ADD go.sum .
#  将Go模块安装到定义的目录中
RUN go mod download
ADD . .
# 声明服务运行在8010端口
EXPOSE 8010
# 指定维护者的名字
MAINTAINER wangyi

# 编译程序
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o blog main.go

FROM scratch as prod
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY --from=build /go/release/blog /
COPY --from=build /go/release/conf ./conf


CMD ["/blog"]



