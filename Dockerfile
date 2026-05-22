ARG rust=latest
FROM rust:${rust} AS build
RUN apt-get update && apt-get install gcc-$(arch | tr _ -)-linux-gnu musl-tools -y
RUN rustup target add $(arch)-unknown-linux-musl
ARG wasmtime
RUN cargo install --target $(arch)-unknown-linux-musl wasmtime-cli${wasmtime:+@${wasmtime}}
FROM cgr.dev/chainguard/static:latest
COPY --from=build /usr/local/cargo/bin/wasmtime /usr/bin/wasmtime
CMD ["/usr/bin/wasmtime"]
