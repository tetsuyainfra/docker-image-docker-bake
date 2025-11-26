# Docker Bake configuration for multi-architecture builds
# This file defines targets for building x64 (amd64) and arm64 images

# Define a group to build all targets
group "default" {
  targets = ["app"]
}

# Define the main application target with multi-platform support
target "app" {
  context    = "."
  dockerfile = "Dockerfile"
  
  # Support both amd64 (x64) and arm64 platforms
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  
  # Tag configuration
  tags = [
    "docker-bake-example:latest",
    "docker-bake-example:multi-arch"
  ]
  
  # Output configuration - can be modified based on needs
  # For local builds, use type=docker (default)
  # For registry push, use type=registry
  output = ["type=docker"]
}

# Optional: Define separate targets for each architecture
target "app-amd64" {
  inherits   = ["app"]
  platforms  = ["linux/amd64"]
  tags       = ["docker-bake-example:amd64"]
}

target "app-arm64" {
  inherits   = ["app"]
  platforms  = ["linux/arm64"]
  tags       = ["docker-bake-example:arm64"]
}

# Group for building all architecture-specific images
group "all-archs" {
  targets = ["app-amd64", "app-arm64"]
}
