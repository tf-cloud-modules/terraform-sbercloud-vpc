terraform {
  required_version = ">= 0.13.1"

  required_providers {
    sbercloud = {
      source  = "sbercloud-terraform/sbercloud"
      version = ">= 1.9.0"
    }
  }
}