# variableの定義は環境変数から値を取り込む

variable "HTTP_PROXY" {
  type = string
  default = null
}
variable "HTTPS_PROXY" {
  type = string
  default = null
}

variable "TAG" {
    default = "latest"
}

group "default" {
    targets = ["app"]
}

target "app" {
    dockerfile = "Dockerfile.alpine"
    context    = "./src"
    tags = ["webapp:${TAG}"]
    // platforms = [ "linux/amd64", "linux/arm64"]
    args = {
      HTTP_PROXY = HTTP_PROXY
      HTTPS_PROXY = HTTPS_PROXY
    }
}

target "debian" {
    dockerfile = "Dockerfile.debian"
    context    = "./src"
    tags = ["mydebian:${TAG}"]
    labels = {
      "org.opencontainers.image.title" = "mydebian-title"
      "org.opencontainers.image.version" = "${TAG}"
    }
    platforms = [ "linux/amd64", "linux/arm64"]
    args = {
      HTTP_PROXY = HTTP_PROXY
      HTTPS_PROXY = HTTPS_PROXY
    }
}