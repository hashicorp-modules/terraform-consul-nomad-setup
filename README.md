# terraform-consul-nomad-setup

Terraform module that can be used to apply a default sample configuration to a
Consul cluster to integrate it with [Nomad workload identity][nomad_wid] JWTs.

Terraform Registry:
https://registry.terraform.io/modules/hashicorp-modules/nomad-setup/consul/

## Usage

The `examples` directory contains sample Terraform configuration of how to use
this module. Below are some details of how to further customize its use.

### Default sample configuration

This example uses the default sample configuration provided by the module. It
allows allocations to register services and tasks to access any value in
Consul's KV and service catalog.

```hcl
module "consul_setup" {
  source = "hashicorp-modules/nomad-setup/consul"

  nomad_jwks_url = "https://nomad.example.com/.well-known/jwks.json"
}
```

### Custom policy

This example uses a custom policy to limit task access to just the KV path
`env/prod`.

```hcl
resource "consul_acl_policy" "allow_kv_read_prod" {
  name  = "allow-kv-read-prod"
  rules = <<EOF
key_prefix "env/prod" {
  policy = "read"
}

service_prefix "" {
  policy = "read"
}
EOF
}

module "consul_setup" {
  source = "hashicorp-modules/nomad-setup/consul"

  nomad_jwks_url = "http://localhost:4646/.well-known/jwks.json"

  tasks_policy_ids = [
    consul_acl_policy.allow_kv_read_prod_config.id,
  ]
}
```

### Consul Enterprise Namespaces

This module should always be applied to the `default` namespace in Consul. Use
the `auth_method_namespace_rules` variable to specify mappings from Nomad
workload identity claims to other Consul namespaces.

```hcl
module "consul_setup" {
  source = "hashicorp-modules/nomad-setup/consul"

  nomad_jwks_url = "http://localhost:4646/.well-known/jwks.json"

  auth_method_namespace_rules = [
    {
      bind_namespace = "$${value.consul_namespace}"
      selector       = "\"consul_namespace\" in value"
    }
  ]
}
```

[nomad_wid]: https://developer.hashicorp.com/nomad/docs/concepts/workload-identity
