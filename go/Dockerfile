FROM golang:1.11.0-stretch AS build
RUN go get -u github.com/go-redis/redis

ADD . /src
RUN cd /src && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o goapp

# final stage
FROM alpine:3.8 AS runtime
COPY --from=build /src/goapp /app/
WORKDIR /app
ENTRYPOINT ./goapp