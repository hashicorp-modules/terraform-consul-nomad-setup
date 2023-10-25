# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "services_auth_method_name" {
  description = "The name of the auth method used by Nomad to register services."
  type        = string
  default     = "nomad-workloads"
}

variable "tasks_auth_method_name" {
  description = "The name of the auth method used by Nomad tasks to access Consul data."
  type        = string
  default     = "nomad-tasks"
}

variable "nomad_jwks_url" {
  description = "The URL used by Consul to access Nomad's JWKS information."
  type        = string
}

variable "tasks_default_policy_name" {
  description = "The name of the default Consul ACL policy created for Nomad tasks when `tasks_policy_ids` is not defined."
  type        = string
  default     = "nomad-task"
}

variable "tasks_policy_ids" {
  description = "A list of ACL policy IDs to apply to tokens generated for Nomad tasks."
  type        = list(string)
  default     = []
}

variable "audience" {
  description = "The `aud` value set on Nomad workload identity JWTs."
  type        = string
  default     = "consul.io"
}

variable "nomad_namespaces" {
  description = "The list of Nomad namespaces to bind rules."
  type        = list(string)
  default     = ["default"]
}
