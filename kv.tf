resource "vault_mount" "kvv2" {
  path        = var.vault_kv_path
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_backend_v2" "tfe_config" {
  mount                = vault_mount.kvv2.path
  max_versions         = 5
  delete_version_after = 12600
  cas_required         = false
}
resource "vault_kv_secret_v2" "tfe_config" {
  mount                      = vault_mount.kvv2.path
  name                       = var.vault_secret_path
  delete_all_versions        = true
  #cas                        = 0
  data_json                  = jsonencode(
  {
    tfe_database_password = var.auto_generate_secrets == true? random_password.rds_password.result : var.db_password,
    tfe_encryption = var.auto_generate_secrets == true? random_password.encryption_password.result : var.tfe_encryption,
    tfe_license = var.tfe_license,
    tfe_redis_password = var.auto_generate_secrets == true? random_password.redis_password.result : var.redis_password
  }
  )
/*    options = {
    "cas": 0
  }  */
}