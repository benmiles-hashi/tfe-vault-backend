variable "vault_addr" {
    description = "Vault FQDN"
}
variable "vault_user" {
  default = "admin"
}
variable "vault_password" {
  description = "password with access to create resources"
  sensitive = true
}
variable "vault_namespace" {
  description = "Vault Namespace to hold secrets"
  default = "admin"
}
variable "vault_secret_path" {
  default = "tfe_config"
}
variable "vault_kv_path" {
  default = "kvv2"
}
variable "tfe_license" {
  description = "Copy TFE License from file"
}
variable "tfe_encryption" {
    description = "TFE Encryption Password"
    sensitive = false
}
variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}
variable "redis_password" {
    description = "Redis User password"
    sensitive = true
}
variable "auto_generate_secrets" {
  default = false
}