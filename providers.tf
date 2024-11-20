terraform {
  required_version = ">= 1.5.3"
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
provider "vault" {
    address = var.vault_addr
    namespace = var.vault_namespace
    auth_login_userpass {
      username = var.vault_user
      password = var.vault_password
  }
}
provider "random" {
  # Configuration options
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "random_password" "redis_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "random_password" "encryption_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}