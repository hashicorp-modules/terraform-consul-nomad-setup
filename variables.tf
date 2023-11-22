# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Required variables.

variable "nomad_jwks_url" {
  description = "The URL used by Consul to access Nomad's JWKS information. It should be reachable by all Consul agents and resolve to multiple Nomad agents for high-availability, such as through a proxy or a DNS entry with multiple IP addresses."
  type        = string
}

# Optional variables.

variable "services_auth_method_name" {
  description = "The name of the auth method used to register Nomad services."
  type        = string
  default     = "nomad-services"
}

variable "tasks_auth_method_name" {
  description = "The name of the auth method used to access Consul data by Nomad tasks."
  type        = string
  default     = "nomad-tasks"
}

variable "tasks_default_policy_name" {
  description = "The name of the default Consul ACL policy created for Nomad tasks when `tasks_policy_ids` is not defined."
  type        = string
  default     = "nomad-tasks"
}

variable "tasks_policy_ids" {
  description = "A list of ACL policy IDs to apply to tokens generated for Nomad tasks."
  type        = list(string)
  default     = []
}

variable "audience" {
  description = "The `aud` value set on Nomad workload identities for Consul. Must match the used in the Nomad, such as the agent configuration for `consul.task_identity.aud` and `consul.service_identity.aud` and the job values for `service.identity.aud` and `task.identity.aud`."
  type        = string
  default     = "consul.io"
}

variable "nomad_namespaces" {
  description = "A list of Nomad namespaces where jobs that need access to Consul are deployed. A Consul ACL role is created for each namespace."
  type        = list(string)
  default     = ["default"]
}
