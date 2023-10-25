# terraform-consul-nomad-setup

Terraform module that can be used to apply a default sample configuration to a
Consul cluster to integrate it with [Nomad workload identity][nomad_wid] JWTs.

## Usage

```hcl
module "consul_setup" {
  source = "github.com/hashicorp/terraform-consul-nomad-setup"

  nomad_jwks_url = "https://nomad.example.com/.well-known/jwks.json"
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
| <a name="input_audience"></a> [audience](#input\_audience) | The `aud` value set on Nomad workload identity JWTs. | `string` | `"consul.io"` | no |
| <a name="input_nomad_jwks_url"></a> [nomad\_jwks\_url](#input\_nomad\_jwks\_url) | The URL used by Consul to access Nomad's JWKS information. | `string` | n/a | yes |
| <a name="input_nomad_namespaces"></a> [nomad\_namespaces](#input\_nomad\_namespaces) | The list of Nomad namespaces to bind rules. | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_services_auth_method_name"></a> [services\_auth\_method\_name](#input\_services\_auth\_method\_name) | The name of the auth method used by Nomad to register services. | `string` | `"nomad-workloads"` | no |
| <a name="input_tasks_auth_method_name"></a> [tasks\_auth\_method\_name](#input\_tasks\_auth\_method\_name) | The name of the auth method used by Nomad tasks to access Consul data. | `string` | `"nomad-tasks"` | no |
| <a name="input_tasks_policy_name"></a> [tasks\_policy\_name](#input\_tasks\_policy\_name) | The name of the Consul ACL policy created for Nomad tasks to access Consul data. | `string` | `"nomad-task"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nomad_client_config"></a> [nomad\_client\_config](#output\_nomad\_client\_config) | A sample Consul configuration to be set in a Nomad client agent configuration file. |
| <a name="output_nomad_server_config"></a> [nomad\_server\_config](#output\_nomad\_server\_config) | A sample Consul configuration to be set in a Nomad server agent configuration file. |

[nomad_wid]: https://developer.hashicorp.com/nomad/docs/concepts/workload-identity
