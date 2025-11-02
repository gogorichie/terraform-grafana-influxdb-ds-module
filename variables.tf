variable "grafana_url" {
  type        = string
  default     = null
  description = "The URL of the Grafana server."

}
variable "grafana_auth" {
  type        = string
  default     = null
  description = "Authentication credentials for accessing Grafana (e.g., API token)."
}

variable "ds_name" {
  type        = string
  description = "A unique name for the data source."
}

variable "ds_url" {
  type        = string
  description = "The URL for the data source. The type of URL required varies depending on the chosen data source type."
}

variable "basic_auth_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable basic auth for the data source."
}
variable "basic_auth_username" {
  type        = string
  default     = null
  description = "Username for basic authentication."
}
variable "database_name" {
  type        = string
  description = "The name of the InfluxDB database."
}

variable "json_data_encoded" {
  type        = string
  default     = null
  description = "Additional configuration options for the datasource in JSON format."
}

variable "secure_json_data_encoded" {
  type        = string
  default     = null
  description = "Secure configuration options (e.g., passwords, tokens) for the datasource in JSON format."
}
