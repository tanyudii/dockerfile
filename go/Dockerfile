ARG PORT

# build stage
FROM golang:alpine AS build
RUN apk update && apk add --no-cache git
WORKDIR /app
ENV GO111MODULE=on
COPY go.mod go.sum ./
RUN go mod download
COPY . /app
RUN rm -rf ~/.netrc
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GO111MODULE=on go build -ldflags="-w -s" -o /go/bin/app main.go

# production stage
FROM alpine AS production
RUN apk update && apk add --no-cache ca-certificates curl
COPY --from=build /go/bin/app ./
EXPOSE $PORT
ENTRYPOINT ["./app"]