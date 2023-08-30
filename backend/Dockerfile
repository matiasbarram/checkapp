FROM golang:1.19

WORKDIR /checkapp_api

COPY checkapp_api/go.mod checkapp_api/go.sum ./

RUN go mod download

COPY /checkapp_api .

RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-checkapp-api

EXPOSE 8083

CMD ["/docker-checkapp-api"]