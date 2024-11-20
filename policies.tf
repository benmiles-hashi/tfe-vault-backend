data "vault_auth_backend" "userpass" {
    path = "userpass"
}
data "vault_policy_document" "tfe_user_config_policy" {
  rule {
    path         = "${vault_mount.kvv2.path}/data/${vault_kv_secret_v2.tfe_config.name}"
    capabilities = ["read","list"]
    description  = "allow tfe_user to read tfe configuration data "
  }
  rule {
    path         = "${vault_mount.pki_int_milabs_co.path}/issue/${vault_pki_secret_backend_role.int_role.name}"
    capabilities = ["create", "update"]
    description  = "allow tfe_user to request tfe certificate "
  }
  rule {
    path = "auth/token/create"
    capabilities = ["update"]
    description = "Allow user to update own token"
  }
  rule {
    path = "sys/mounts/${vault_mount.pki_int_milabs_co.path}"
    capabilities = ["read"]
    description = "Allow tfe to read mount"
  }
}
resource "vault_policy" "tfe_user_config_policy" {
  name   = "tfe_user_config_policy"
  policy = data.vault_policy_document.tfe_user_config_policy.hcl
}
resource "vault_generic_endpoint" "client_userpass_password" {
  path                 = "auth/userpass/users/tfe_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "password": "${random_password.password.result}",
  "policies": "default, ${vault_policy.tfe_user_config_policy.name}"
}
EOT
}
