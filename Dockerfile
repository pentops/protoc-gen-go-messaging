FROM golang:1.21 AS builder

WORKDIR /src

ADD . .
ARG VERSION
RUN \
  --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  CGO_ENABLED=0 \
  GOOS=linux \
  go build \
  -ldflags="-X main.Version=$VERSION" \
  -o /protoc-gen-go-messaging .

FROM scratch
LABEL org.opencontainers.image.source = "https://github.com/pentops/protoc-gen-go-messaging"
COPY --from=builder /protoc-gen-go-messaging /
ENTRYPOINT ["/protoc-gen-go-messaging"]

