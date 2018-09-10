FROM golang:1.10.4-alpine3.8 AS build
ADD . /src
RUN cd /src && go build -o goapp

# final stage
FROM alpine:3.8 AS runtime
WORKDIR /app
COPY --from=build /src/goapp /app/
ENTRYPOINT ./goapp