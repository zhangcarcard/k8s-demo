# FROM golang:latest AS build
 
# WORKDIR /test
# COPY . /test
# RUN go env -w GOPROXY=https://goproxy.cn,direct
# RUN CGO_ENABLED=0 go build -v -o main .
 
# FROM alpine AS api
# RUN mkdir /app
# COPY --from=build /test/main /app
# WORKDIR /app
# ENTRYPOINT ["./main", "-v" ,"1.0"]

FROM golang:latest AS builder

WORKDIR /build
#RUN adduser -u 10001 -D app-runner

COPY . .

RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go mod download
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -a -o main .

FROM alpine AS final

WORKDIR /app
COPY --from=builder /build/main /app/
#COPY --from=builder /build/configs /app/configs
#COPY --from=builder /etc/passwd /etc/passwd
#COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

#RUN mkdir -p /app/log && chown -R app-runner:10001 /app/log && mkdir -p /app/cache && chown -R app-runner:10001 /app/cache

#USER app-runner
ENTRYPOINT ["/app/main", "-v" ,"1.0.3"]
