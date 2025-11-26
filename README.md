# docker-image-docker-bake

Docker Bake configuration for building multi-architecture Docker images supporting x64 (amd64) and arm64 platforms.

## Overview

This repository testing how to use Docker Bake to build multi-architecture Docker images. The configuration supports building images for both x64 (amd64) and arm64 architectures.

## Prerequisites

- Docker with buildx support (Docker 19.03+)
- Docker Buildx plugin installed

## Configuration Files

- `src/Dockerfile`: Sample multi-architecture compatible Dockerfile
- `docker-bake.yml`: Docker Bake configuration file defining build targets (YAML/Compose format)
