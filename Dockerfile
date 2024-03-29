FROM rust as build

RUN rustup toolchain install nightly
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl

RUN apt-get update
RUN apt-get install musl-tools -y

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
RUN mkdir src
RUN echo "fn main() {}" > src/main.rs

RUN cargo build --release -Zsparse-registry --target x86_64-unknown-linux-musl

COPY src ./src

# now rebuild with the proper main
RUN touch src/main.rs
RUN cargo build --release -Zsparse-registry --target x86_64-unknown-linux-musl

### RUN
FROM scratch

WORKDIR /app

COPY --from=build /app/target/x86_64-unknown-linux-musl/release/killjoy_turret killjoy_turret

CMD ["/app/killjoy_turret"]
