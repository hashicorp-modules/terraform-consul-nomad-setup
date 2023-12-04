job "consul-info" {
  group "consul-info" {
    network {
      port "http" {}
    }

    service {
      name     = "consul-info"
      port     = "http"
      provider = "consul"
    }

    task "consul-info" {
      driver = "docker"

      config {
        image   = "busybox:1.36"
        command = "httpd"
        args    = ["-f", "-p", "${NOMAD_PORT_http}", "-h", "local/www"]
        ports   = ["http"]
      }

      template {
        data        = <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Consul Info</title>
  </head>
  <body>
    <h1>Consul Info</h1>
    <p>Consul Services:</p>
    <ul>
      {{range services}}
        <li>{{.Name}}</li>
      {{end}}
    </ul>
    <p>Consul KV:</p>
    <ul>
      {{range ls "sample"}}
        <li>{{.Key}}: {{.Value}}</li>
      {{end}}
    </ul>
  </body>
</html>
EOF
        destination = "local/www/index.html"
      }
    }
  }
}
