# terraform-consul-nomad-setup

Terraform module that can be used to apply a default sample configuration to a
Consul cluster to integrate it with [Nomad workload identity][nomad_wid] JWTs.

## Usage

Using the default example values.

```hcl
module "consul_setup" {
  source = "github.com/hashicorp/terraform-consul-nomad-setup"

  nomad_jwks_url = "https://nomad.example.com/.well-known/jwks.json"
}
```

Applying custom policies to tokens.

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
  source = "github.com/hashicorp/terraform-consul-nomad-setup"

  nomad_jwks_url = "http://localhost:4646/.well-known/jwks.json"
  tasks_policy_ids = [
    consul_acl_policy.allow_kv_read_prod_config.id,
  ]
}
```

## Resources

| Name | Type |
|------|------|
| [consul_acl_auth_method.services](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_auth_method) | resource |
| [consul_acl_auth_method.tasks](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_auth_method) | resource |
| [consul_acl_binding_rule.services](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_binding_rule) | resource |
| [consul_acl_binding_rule.tasks](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_binding_rule) | resource |
| [consul_acl_policy.tasks](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_policy) | resource |
| [consul_acl_role.tasks](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_audience"></a> [audience](#input\_audience) | The `aud` value set on Nomad workload identities for Consul. Must match the used in the Nomad, such as the agent configuration for `consul.task_identity.aud` and `consul.service_identity.aud` and the job values for `service.identity.aud` and `task.identity.aud`. | `string` | `"consul.io"` | no |
| <a name="input_nomad_jwks_url"></a> [nomad\_jwks\_url](#input\_nomad\_jwks\_url) | The URL used by Consul to access Nomad's JWKS information. It should be reachable by all Consul agents and resolve to multiple Nomad agents for high-availability, such as through a proxy or a DNS entry with multiple IP addresses. | `string` | n/a | yes |
| <a name="input_nomad_namespaces"></a> [nomad\_namespaces](#input\_nomad\_namespaces) | A list of Nomad namespaces where jobs that need access to Consul are deployed. A Consul ACL role is created for each namespace. | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_services_auth_method_name"></a> [services\_auth\_method\_name](#input\_services\_auth\_method\_name) | The name of the auth method used to register Nomad services. | `string` | `"nomad-services"` | no |
| <a name="input_tasks_auth_method_name"></a> [tasks\_auth\_method\_name](#input\_tasks\_auth\_method\_name) | The name of the auth method used to access Consul data by Nomad tasks. | `string` | `"nomad-tasks"` | no |
| <a name="input_tasks_default_policy_name"></a> [tasks\_default\_policy\_name](#input\_tasks\_default\_policy\_name) | The name of the default Consul ACL policy created for Nomad tasks when `tasks_policy_ids` is not defined. | `string` | `"nomad-task"` | no |
| <a name="input_tasks_policy_ids"></a> [tasks\_policy\_ids](#input\_tasks\_policy\_ids) | A list of ACL policy IDs to apply to tokens generated for Nomad tasks. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nomad_client_config"></a> [nomad\_client\_config](#output\_nomad\_client\_config) | A sample Consul configuration to be set in a Nomad client agent configuration file. |
| <a name="output_nomad_server_config"></a> [nomad\_server\_config](#output\_nomad\_server\_config) | A sample Consul configuration to be set in a Nomad server agent configuration file. |
| <a name="output_services_auth_method_id"></a> [services\_auth\_method\_id](#output\_services\_auth\_method\_id) | The ID of the auth method created for Nomad services. |
| <a name="output_tasks_acl_policy_ids"></a> [tasks\_acl\_policy\_ids](#output\_tasks\_acl\_policy\_ids) | A list of IDs of the ACL policies applied to each ACL role. |
| <a name="output_tasks_acl_role_ids"></a> [tasks\_acl\_role\_ids](#output\_tasks\_acl\_role\_ids) | A list of IDs of the ACL roles created for Nomad tasks. |
| <a name="output_tasks_auth_method_id"></a> [tasks\_auth\_method\_id](#output\_tasks\_auth\_method\_id) | The ID of the auth method created for Nomad tasks. |

[nomad_wid]: https://developer.hashicorp.com/nomad/docs/concepts/workload-identity
