# Create a Consul namespace with a random name.
resource "random_pet" "consul_namespace" {}
resource "consul_namespace" "ns" {
  name = random_pet.consul_namespace.id
}

# Setup Consul JWT authentication for tasks and services from Nomad mapping the
# claim consul_namespace from the Nomad workload identity to a Consul
# namespace.
module "consul_setup" {
  source = "./../.."

  nomad_jwks_url = "http://localhost:4646/.well-known/jwks.json"
  auth_method_namespace_rules = [
    {
      bind_namespace = "$${value.consul_namespace}"
      selector       = "\"consul_namespace\" in value"
    }
  ]
}

# Register a Nomad job that uses the Consul namespace.
resource "nomad_job" "example" {
  depends_on = [
    module.consul_setup,
  ]

  jobspec = templatefile(
    "${path.module}/files/example.nomad.hcl",
    {
      tf_consul_namespace = consul_namespace.ns.name
    }
  )
  detach = false
}
