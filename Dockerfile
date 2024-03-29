# syntax=docker/dockerfile:1.7
FROM golang:1.22-alpine AS builder

WORKDIR /code

ENV CGO_ENABLED 0
ENV GOPATH /go
ENV GOCACHE /go-cache

COPY go.mod go.sum .
RUN --mount=type=cache,target=/go/pkg/mod/cache \
    go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod/cache \
    --mount=type=cache,target=/go-cache \
    go build -o bin/server main.go

CMD ["/code/bin/server"]

FROM builder as dev-envs

RUN apk update
RUN apk add git
RUN addgroup -S docker
RUN adduser -S --shell /bin/bash --ingroup docker

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["go", "run", "main.go"]

FROM scratch
COPY --from=builder /code/bin/server /usr/local/bin/server
CMD ["/usr/local/bin/server"]

