FROM golang:latest

RUN mkdir -p /api

WORKDIR /api

ADD . /api

RUN go get github.com/gorilla/mux
RUN go get github.com/mattn/go-sqlite3
RUN go get github.com/rs/cors

RUN go build -o api

CMD ["./api"]