# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.18"
    }
  }
}
