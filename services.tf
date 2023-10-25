# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Configuration for Nomad services.
#
# Theses resources allow Nomad allocations to exchange their workload identity
# JSON Web Tokens (JWTs) for Consul ACL tokens that are used to manage services
# lifecycle and to access other catalog information.

# consul_acl_auth_method.services is the JWT auth method used by Nomad
# allocations to request Consul ACL tokens via a login request.
resource "consul_acl_auth_method" "services" {
  name         = var.services_auth_method_name
  display_name = var.services_auth_method_name
  description  = "JWT auth method for services registered from Nomad"
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

# consul_acl_binding_rule.services binds consul_acl_auth_method.services to a
# service identity.
#
# This ensures that tokens generated by the auth method have the right
# permissions to manage the service lifecycle.
#
# Refer to Consul's documentation on binding rules and service identities for
# more information.
# https://developer.hashicorp.com/consul/docs/security/acl/auth-methods#binding-rules
# https://developer.hashicorp.com/consul/docs/security/acl/acl-roles#service-identities
resource "consul_acl_binding_rule" "services" {
  auth_method = consul_acl_auth_method.services.name
  description = "Binding rule for services registered from Nomad"
  bind_type   = "service"


  # bind_name matches the pattern used by Nomad to register services in Consul
  # and should not be modified.
  bind_name = "$${value.nomad_namespace}-$${value.nomad_service}"
}
