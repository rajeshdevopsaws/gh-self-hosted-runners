resource "random_string" "random_name" {
  length  = 4
  special = false
  upper   = false
  numeric  = true
}
  