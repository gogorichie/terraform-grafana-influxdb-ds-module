# Terraform Block
provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_auth
}

# Resource Block
resource "grafana_data_source" "influxdb" {
  type                     = "influxdb"
  name                     = var.ds_name
  url                      = var.ds_url
  basic_auth_enabled       = var.basic_auth_enabled
  basic_auth_username      = var.basic_auth_username
  database_name            = var.database_name
  json_data_encoded        = var.json_data_encoded
  secure_json_data_encoded = var.secure_json_data_encoded
}

output "id" {
  value = grafana_data_source.influxdb.id
}
