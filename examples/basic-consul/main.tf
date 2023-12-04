locals {
  consul_info_service = data.consul_service.consul_info.service[0]
}

# Setup Consul JWT authentication for tasks and services from Nomad.
module "consul_setup" {
  source = "./../.."

  nomad_jwks_url = "http://localhost:4646/.well-known/jwks.json"
}

# Create sample Consul KV data.
resource "consul_keys" "sample" {
  key {
    path  = "sample/key1"
    value = "value1"
  }

  key {
    path  = "sample/key2"
    value = "value2"
  }
}

# Register Nomad job.
resource "nomad_job" "consul_info" {
  depends_on = [
    module.consul_setup,
    consul_keys.sample,
  ]

  jobspec = file("${path.module}/files/consul-info.nomad.hcl")
  detach  = false
}

# Read data about the service registered by Nomad.
data "consul_service" "consul_info" {
  depends_on = [
    nomad_job.consul_info,
  ]

  name = "consul-info"
}

# Output URL to access the service registered by Nomad.
output "consul_info_service" {
  value = "http://${local.consul_info_service.address}:${local.consul_info_service.port}"
}
