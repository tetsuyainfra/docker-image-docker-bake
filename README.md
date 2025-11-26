# docker-image-docker-bake

Docker Bake configuration for building multi-architecture Docker images supporting x64 (amd64) and arm64 platforms.

## Overview

This repository demonstrates how to use Docker Bake to build multi-architecture Docker images. The configuration supports building images for both x64 (amd64) and arm64 architectures.

## Prerequisites

- Docker with buildx support (Docker 19.03+)
- Docker Buildx plugin installed

## Configuration Files

- `Dockerfile`: Sample multi-architecture compatible Dockerfile
- `docker-bake.hcl`: Docker Bake configuration file defining build targets

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
docker buildx bake all-archs
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
To push multi-architecture images to a registry, modify the output in `docker-bake.hcl` or use command-line options:
```bash
docker buildx bake app --push --set app.tags=your-registry/image:tag
```

### Run the Built Image
After building, you can run the image:
```bash
docker run --rm docker-bake-example:latest
```

## Configuration Details

The `docker-bake.hcl` file defines:
- **app**: Multi-platform target (amd64 + arm64)
- **app-amd64**: AMD64/x64 specific build
- **app-arm64**: ARM64 specific build
- **all-archs**: Group target to build all architecture-specific images

## Customization

You can customize the build by:
1. Modifying the `Dockerfile` for your application needs
2. Updating platform lists in `docker-bake.hcl`
3. Changing tags and output configurations
4. Adding build arguments or cache configurations

## Notes

- Multi-architecture builds require QEMU for cross-compilation when building for platforms different from your host
- The default output type is `docker` (local image), which loads only the native architecture
- For true multi-arch manifest creation, use `output = ["type=registry"]` or `--push` flag
