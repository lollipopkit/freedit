# Dockerfile for Freedit
FROM rust:1.89-slim AS builder

# Install system dependencies for building
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Cargo files first for better caching
COPY Cargo.toml Cargo.lock build.rs ./

# Copy source code
COPY src/ src/
COPY templates/ templates/
COPY static/ static/
COPY i18n/ i18n/
COPY examples/ examples/

# Build the application in release mode
RUN cargo build --release

# Runtime stage
FROM bitnami/minideb:latest

# Install runtime dependencies
RUN install_packages --sync \
    ca-certificates \
    curl

# Set working directory
WORKDIR /app

# Copy the binary from builder stage
COPY --from=builder /app/target/release/freedit /usr/local/bin/freedit

# Copy configuration file
COPY config.toml ./

# Create data directories with proper permissions
RUN mkdir -p data/imgs/avatars data/imgs/inn_icons data/imgs/upload data/tantivy data/podcasts data/snapshots \
    && chown -R freedit:freedit /app

# Expose port
EXPOSE 3001

# Set environment variables
ENV RUST_LOG=info

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3001/ || exit 1

# Run the application
CMD ["freedit"]