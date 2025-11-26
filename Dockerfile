# Multi-architecture Docker image example
FROM alpine:3.19

# Add labels for metadata
LABEL org.opencontainers.image.title="docker-bake-example"
LABEL org.opencontainers.image.description="Example multi-architecture image built with Docker Bake"

# Install basic utilities
RUN apk add --no-cache \
    curl \
    ca-certificates

# Show architecture information
RUN echo "Building for architecture: $(uname -m)"

# Create a simple script to show the architecture
RUN echo '#!/bin/sh' > /usr/local/bin/show-arch && \
    echo 'echo "Architecture: $(uname -m)"' >> /usr/local/bin/show-arch && \
    echo 'echo "Platform: $(uname -s)"' >> /usr/local/bin/show-arch && \
    chmod +x /usr/local/bin/show-arch

CMD ["/usr/local/bin/show-arch"]
