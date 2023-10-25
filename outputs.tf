# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "nomad_client_config" {
  description = "A sample Consul configuration to be set in a Nomad client agent configuration file."
  value       = <<EOF
consul {
  enabled             = true
  address             = "<Consul address>"
  service_auth_method = "${consul_acl_auth_method.services.name}"
  task_auth_method    = "${consul_acl_auth_method.tasks.name}"
}
EOF
}

output "nomad_server_config" {
  description = "A sample Consul configuration to be set in a Nomad server agent configuration file."
  value       = <<EOF
consul {
  enabled = true

  service_identity {
    aud = ["consul.io"]
  }

  task_identity {
    aud = ["consul.io"]
  }
}
EOF
}
