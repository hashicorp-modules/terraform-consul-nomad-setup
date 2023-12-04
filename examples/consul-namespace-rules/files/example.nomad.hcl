job "example" {

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    consul {
      namespace = "${tf_consul_namespace}"
    }

    service {
      port     = "db"
      name     = "redis"
      provider = "consul"
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
      }
    }
  }
}
