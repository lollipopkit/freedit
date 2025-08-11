FROM bitnami/minideb:latest

RUN install_packages ca-certificates
COPY target/release/freedit /app/freedit
ENV RUST_LOG=info
WORKDIR /app
CMD ["./freedit"]