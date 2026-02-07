FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
RUN go build -o training-service .

FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/training-service /app/training-service
EXPOSE 8081
CMD ["/app/training-service"]
