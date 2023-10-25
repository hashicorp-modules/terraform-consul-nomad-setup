# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  create_default_policy = length(var.tasks_policy_ids) == 0
  tasks_policy_ids      = local.create_default_policy ? consul_acl_policy.tasks[*].id : var.tasks_policy_ids
}

# Configuration for Nomad services.
resource "consul_acl_auth_method" "services" {
  name         = var.services_auth_method_name
  display_name = var.services_auth_method_name
  description  = "JWT auth method for services registered by Nomad"
  type         = "jwt"

  config_json = jsonencode({
    JWKSURL          = var.nomad_jwks_url
    JWTSupportedAlgs = ["RS256"]
    BoundAudiences   = var.audience
    ClaimMappings = {
      nomad_namespace = "nomad_namespace"
      nomad_job_id    = "nomad_job_id"
      nomad_task      = "nomad_task"
      nomad_service   = "nomad_service"
    }
  })
}

resource "consul_acl_binding_rule" "services" {
  auth_method = consul_acl_auth_method.services.name
  description = "Binding rule for services registered by Nomad"
  bind_type   = "service"
  bind_name   = "$${value.nomad_namespace}-$${value.nomad_service}"
}

# Configuration for Nomad tasks.
resource "consul_acl_auth_method" "tasks" {
  name         = var.tasks_auth_method_name
  display_name = var.tasks_auth_method_name
  description  = "JWT auth method used by Nomad tasks"
  type         = "jwt"

  config_json = jsonencode({
    JWKSURL          = var.nomad_jwks_url
    JWTSupportedAlgs = ["RS256"]
    BoundAudiences   = [var.audience]
    ClaimMappings = {
      nomad_namespace = "nomad_namespace"
      nomad_job_id    = "nomad_job_id"
      nomad_task      = "nomad_task"
      nomad_service   = "nomad_service"
    }
  })
}

resource "consul_acl_role" "tasks" {
  for_each = toset(var.nomad_namespaces)

  name        = "nomad-tasks-${each.key}"
  description = "ACL role for Nomad tasks in the ${each.key} Nomad namespace"
  policies    = local.tasks_policy_ids
}

resource "consul_acl_policy" "tasks" {
  count = local.create_default_policy ? 1 : 0

  name        = var.tasks_default_policy_name
  description = "ACL policy used by Nomad tasks"

  rules = <<EOF
key_prefix "" {
  policy = "read"
}

service_prefix "" {
  policy = "read"
}
EOF
}

resource "consul_acl_binding_rule" "tasks" {
  auth_method = consul_acl_auth_method.tasks.name
  description = "Binding rule for Nomad tasks"
  bind_type   = "role"
  bind_name   = "nomad-$${value.nomad_namespace}"
}
