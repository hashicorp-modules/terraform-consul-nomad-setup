terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.18"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "~>2.0.0"
    }
  }
}

provider "nomad" {
  address = "http://localhost:4646"
}

provider "consul" {
  address = "http://localhost:8500"
}
