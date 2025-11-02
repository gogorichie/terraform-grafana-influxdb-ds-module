variable "grafana_url" {
  type        = string
  default     = null
  description = "The URL for the data source. The type of URL required varies depending on the chosen data source type."

}
variable "grafana_auth" {
  type    = string
  default = null
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
  type        = string
  default     = "true"
  description = "Whether to enable basic auth for the data source"
}
variable "basic_auth_username" {
  type    = string
  default = null
}
variable "database_name" {
  type = string
}

variable "json_data_encoded" {
  type    = string
  default = null
}

variable "secure_json_data_encoded" {
  type    = string
  default = null
}
