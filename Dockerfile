FROM bitnami/minideb:latest

# Install runtime dependencies
RUN install_packages --sync \
    ca-certificates \
    curl

# Set working directory
WORKDIR /app

# Copy the binary from builder stage
COPY ./target/release/freedit /app/freedit

# Set environment variables
ENV RUST_LOG=info

# Run the application
CMD ["freedit"]