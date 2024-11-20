output "user_pass" {
  value = (jsondecode (vault_generic_endpoint.client_userpass_password.data_json)).password
  sensitive = true
}