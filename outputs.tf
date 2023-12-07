# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "auth_method_id" {
  description = "The ID of the auth method created for Nomad workloads."
  value       = consul_acl_auth_method.nomad.id
}

output "tasks_acl_role_ids" {
  description = "A list of IDs of the ACL roles created for Nomad tasks."
  value       = [for k, v in consul_acl_role.tasks : v.id]
}

output "tasks_acl_policy_ids" {
  description = "A list of IDs of the ACL policies applied to each ACL role."
  value       = local.tasks_policy_ids
}

output "nomad_client_config" {
  description = "A sample Consul configuration to be set in a Nomad client agent configuration file."
  value       = <<EOF
consul {
  enabled = true
  address = "<Consul address>"

  # Nomad agents still need a Consul token in order to register themselves
  # for automated clustering. It is recommended to set the token using the
  # CONSUL_HTTP_TOKEN environment variable instead of writing it in the
  # configuration file.

  # Consul Enterprise only.
  # namespace = "<namespace>"

  # Consul mTLS configuration.
  # ssl       = true
  # ca_file   = "/var/ssl/bundle/ca.bundle"
  # cert_file = "/etc/ssl/consul.crt"
  # key_file  = "/etc/ssl/consul.key"

  service_auth_method = "${consul_acl_auth_method.nomad.name}"
  task_auth_method    = "${consul_acl_auth_method.nomad.name}"
}
EOF
}

output "nomad_server_config" {
  description = "A sample Consul configuration to be set in a Nomad server agent configuration file."
  value       = <<EOF
consul {
  enabled = true
  address = "<Consul address>"

  # Nomad agents still need a Consul token in order to register themselves
  # for automated clustering. It is recommended to set the token using the
  # CONSUL_HTTP_TOKEN environment variable instead of writing it in the
  # configuration file.

  # Consul Enterprise only.
  # namespace = "<namespace>"

  # Consul mTLS configuration.
  # ssl       = true
  # ca_file   = "/var/ssl/bundle/ca.bundle"
  # cert_file = "/etc/ssl/consul.crt"
  # key_file  = "/etc/ssl/consul.key"

  service_identity {
    aud = ["${var.audience}"]
    ttl = "1h"
  }

  task_identity {
    aud = ["${var.audience}"]
    ttl = "1h"
  }
}
EOF
}
