# Terraform Grafana InfluxDB Data Source Module

A Terraform module that provisions a [Grafana InfluxDB data source](https://grafana.com/docs/grafana/latest/datasources/influxdb/) using the [`grafana/grafana`](https://registry.terraform.io/providers/grafana/grafana/latest) provider. Manage your Grafana InfluxDB data sources as code — versioned, reviewable, and reproducible.

![Image](https://gogorichiesitefiles.blob.core.windows.net/publicfiles/tgi-image.jpg)

## Features

- Provisions a single `grafana_data_source` resource of type `influxdb`.
- Supports basic authentication and arbitrary JSON / secure JSON configuration.
- Returns the created data source `id` as an output for downstream use.
- Compatible with Terraform `>= 1.0` and the Grafana provider `~> 4.0`.

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.0   |
| grafana   | ~> 4.0   |

## Usage

### Basic example

```hcl
module "influxdb_ds" {
  source  = "gogorichie/influxdb-ds-module/grafana"
  version = "~> 1.0"

  grafana_url   = "https://grafana.example.com"
  grafana_auth  = var.grafana_auth_token

  ds_name       = "my-influxdb"
  ds_url        = "http://influxdb.example.net:8086/"
  database_name = "metrics"
}
```

### With basic auth and InfluxQL settings

```hcl
module "influxdb_ds" {
  source  = "gogorichie/influxdb-ds-module/grafana"
  version = "~> 1.0"

  grafana_url   = "https://grafana.example.com"
  grafana_auth  = var.grafana_auth_token

  ds_name             = "influxdb-prod"
  ds_url              = "http://influxdb.example.net:8086/"
  database_name       = "metrics"
  basic_auth_enabled  = true
  basic_auth_username = "grafana_reader"

  secure_json_data_encoded = jsonencode({
    basicAuthPassword = var.influxdb_password
  })

  json_data_encoded = jsonencode({
    httpMode = "GET"
  })
}
```

> **Tip:** Pass secrets such as `grafana_auth` and `secure_json_data_encoded` from a secrets manager or environment-bound variables — never hard-code them.

## Inputs

| Name                       | Description                                                                  | Type     | Default | Required |
| -------------------------- | ---------------------------------------------------------------------------- | -------- | ------- | :------: |
| `ds_name`                  | A unique name for the data source.                                           | `string` | n/a     |   yes    |
| `ds_url`                   | URL for the InfluxDB data source (e.g., `http://influxdb.example.net:8086`). | `string` | n/a     |   yes    |
| `database_name`            | Name of the InfluxDB database.                                               | `string` | n/a     |   yes    |
| `grafana_url`              | URL of the Grafana server.                                                   | `string` | `null`  |    no    |
| `grafana_auth`             | Authentication credentials for Grafana (e.g., API token).                    | `string` | `null`  |    no    |
| `basic_auth_enabled`       | Whether to enable basic auth for the data source.                            | `bool`   | `true`  |    no    |
| `basic_auth_username`      | Username for basic authentication.                                           | `string` | `null`  |    no    |
| `json_data_encoded`        | Additional data source configuration as a JSON-encoded string.               | `string` | `null`  |    no    |
| `secure_json_data_encoded` | Secure configuration (passwords, tokens) as a JSON-encoded string.           | `string` | `null`  |    no    |

## Outputs

| Name | Description                              |
| ---- | ---------------------------------------- |
| `id` | The ID of the created Grafana data source. |

## Provider Configuration

This module configures the `grafana` provider internally using the `grafana_url` and `grafana_auth` inputs, so you can use it without declaring a separate `provider "grafana"` block. If you already configure the provider in your root module, you can omit those two inputs.

## Contributing

Contributions are welcome through [GitHub Issues and Pull Requests](https://github.com/gogorichie/terraform-grafana-influxdb-ds-module).

### 1. Fork and create a branch

- Fork this repository.
- Create a feature branch from `main` with a descriptive name, for example: `feat/add-timeout-setting` or `fix/readme-example`.

### 2. Make focused changes

- Keep PRs scoped to this module's purpose: provisioning a single `grafana_data_source` of type `influxdb`.
- Avoid unrelated refactors in the same PR.
- Never commit secrets, Terraform state files, or `.tfvars` files.

### 3. Run local validation

Run the following commands before opening a PR:

```powershell
terraform fmt -recursive
terraform init -backend=false
terraform validate
tflint --init
tflint
```

If you use pre-commit, you can also run:

```powershell
pre-commit run --all-files
```

### 4. Keep documentation in sync

- If you change inputs or outputs, regenerate the README tables using `terraform-docs` (the `terraform_docs` pre-commit hook handles this).
- Include usage updates in examples when behavior changes.

### 5. Open a pull request

- Describe what changed and why.
- Include any breaking-change notes clearly in the PR description.
- Apply an appropriate release label when possible:
  - `semver:major` for breaking changes
  - `semver:minor` (or `enhancement`) for new backward-compatible features
  - `semver:patch` (or `bug`) for fixes
