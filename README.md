# docker-image-docker-bake

Docker Bake configuration for building multi-architecture Docker images supporting x64 (amd64) and arm64 platforms.

## Overview

This repository demonstrates how to use Docker Bake to build multi-architecture Docker images. The configuration supports building images for both x64 (amd64) and arm64 architectures.

**Note**: The configuration uses docker-compose.yml format (YAML), which is one of the standard formats supported by Docker Bake alongside HCL and JSON.

## Prerequisites

- Docker with buildx support (Docker 19.03+)
- Docker Buildx plugin installed

## Configuration Files

- `Dockerfile`: Sample multi-architecture compatible Dockerfile
- `docker-compose.yml`: Docker Bake configuration file defining build targets (YAML/Compose format)

## Available Targets

### Default Target: `app`
Builds a multi-architecture image for both amd64 and arm64:
```bash
docker buildx bake
# or explicitly
docker buildx bake app
```

### Architecture-Specific Targets

Build only for amd64 (x64):
```bash
docker buildx bake app-amd64
```

Build only for arm64:
```bash
docker buildx bake app-arm64
```

Build all architecture-specific images:
```bash
docker buildx bake app-amd64 app-arm64
```

## Usage Examples

### Validate Configuration
Check the bake configuration without building:
```bash
docker buildx bake --print
docker buildx bake --print app-amd64
docker buildx bake --print app-arm64
```

### Build Multi-Architecture Image
Build for both platforms (requires buildx with cross-platform support):
```bash
docker buildx bake app
```

### Build and Push to Registry
To push multi-architecture images to a registry, modify the configuration in `docker-compose.yml` or use command-line options:
```bash
docker buildx bake app --push --set app.tags=your-registry/image:tag
```

### Run the Built Image
After building, you can run the image:
```bash
docker run --rm docker-bake-example:latest
```

## Configuration Details

The `docker-compose.yml` file (in docker-compose YAML format) defines:
- **app**: Multi-platform target (amd64 + arm64)
- **app-amd64**: AMD64/x64 specific build
- **app-arm64**: ARM64 specific build

All services are included in the default group for easy building.

## Customization

You can customize the build by:
1. Modifying the `Dockerfile` for your application needs
2. Updating platform lists in `docker-compose.yml`
3. Changing tags and image names
4. Adding build arguments or additional services

## Notes

- Multi-architecture builds require QEMU for cross-compilation when building for platforms different from your host
- The default output type is `docker` (local image), which loads only the native architecture
- For true multi-arch manifest creation, use `output = ["type=registry"]` or `--push` flag
