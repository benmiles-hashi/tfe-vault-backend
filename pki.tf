resource "vault_mount" "root" {
  path                      = "pki_milabs_co"
  type                      = "pki"
  description               = "Milabs.co root PKI"
  default_lease_ttl_seconds = 8640000
  max_lease_ttl_seconds     = 8640000
}

resource "vault_pki_secret_backend_config_urls" "example" {
  backend = vault_mount.root.path
  issuing_certificates = [
    "${var.vault_addr}v1/${vault_mount.root.path}/ca",
  ]
  crl_distribution_points = [
    "${var.vault_addr}v1/${vault_mount.root.path}/crl"
  ]
}
resource "vault_pki_secret_backend_root_cert" "root_cert" {
  backend               = vault_mount.root.path
  type                  = "internal"
  common_name           = "milabs.co"
  ttl                   = "365d"
  format                = "pem"
  private_key_format    = "der"
  key_type              = "rsa"
  key_bits              = 4096
  exclude_cn_from_sans  = true
  ou                    = "My OU"
  organization          = "My organization"
}
resource "vault_pki_secret_backend_role" "webserverrole" {
  backend          = vault_mount.root.path
  name             = "milabs-webservers"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["milabs.co", "milab.local"]
  allow_subdomains = true
}
resource "vault_mount" "pki_int_milabs_co" {
  path                  = "pki_int_milabs_co"
  type                  = "pki"
  description           = "PKI engine hosting intermediate CA"
  max_lease_ttl_seconds = 31536000
}
resource "vault_pki_secret_backend_intermediate_cert_request" "milabs_int_csr" {
  backend     = vault_mount.pki_int_milabs_co.path
  type        = vault_pki_secret_backend_root_cert.root_cert.type
  common_name = "milabs.co Intermediate Authority"
}
resource "vault_pki_secret_backend_root_sign_intermediate" "milabs_int_sign" {
  backend              = vault_mount.root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.milabs_int_csr.csr
  common_name          = "milabs.co Intermediate Authority"
  exclude_cn_from_sans = true
  ou                   = "SubUnit"
  organization         = "SubOrg"
  country              = "US"
  locality             = "San Francisco"
  province             = "CA"
  revoke               = true
}

resource "vault_pki_secret_backend_intermediate_set_signed" "milabs" {
  backend     = vault_mount.pki_int_milabs_co.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.milabs_int_sign.certificate
}
resource "vault_pki_secret_backend_role" "int_role" {
  backend          = vault_mount.pki_int_milabs_co.path
  name             = "milabs-dot-co"
  ttl              = "365d"
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["milabs.co", "milab.local"]
  allow_subdomains = true
}