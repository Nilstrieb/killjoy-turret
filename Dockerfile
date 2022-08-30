FROM rust as build

RUN rustup toolchain install nightly
RUN rustup default nightly

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
RUN mkdir src
RUN echo "fn main() {}" > src/main.rs

RUN cargo build --release -Zsparse-registry

COPY src ./src

# now rebuild with the proper main
RUN touch src/main.rs
RUN cargo build --release -Zsparse-registry

FROM debian:latest

WORKDIR /app

COPY --from=build /app/target/release/killjoy_turret killjoy_turret

CMD ["/app/killjoy_turret"]
