# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project Overview

This is a **Terraform module** that provisions a Grafana InfluxDB data source using the [`grafana/grafana`](https://registry.terraform.io/providers/grafana/grafana/latest) provider. It is published to the Terraform Registry as `gogorichie/influxdb-ds-module/grafana`.

The module is intentionally small and single-purpose: it wraps the `grafana_data_source` resource configured for `type = "influxdb"`.

## Repository Layout

- [main.tf](main.tf) — Provider config + the single `grafana_data_source.influxdb` resource and `id` output.
- [variables.tf](variables.tf) — All input variables (Grafana connection + data source attributes).
- [provider.tf](provider.tf) — `terraform` block with `required_version` and `required_providers` (grafana `~> 4.0`, Terraform `>= 1.0`).
- [README.md](README.md) — Public-facing usage documentation.
- [.tflint.hcl](.tflint.hcl) — TFLint config (recommended preset).
- [.pre-commit-config.yaml](.pre-commit-config.yaml) — Hooks: `terraform_fmt`, `terraform_tflint`, `terraform_validate`, `terraform_checkov`, `terraform_docs`, `detect-secrets`, plus `pre-commit-terraform-vars`.
- [.github/workflows/](.github/workflows) — `ci.yml` (TFLint on PRs), `pr-automation.yml` (auto-close template PRs + Dependabot auto-merge), `release.yml` (release-drafter on merge to `main` + major-version tagging on publish), and `stale.yml` (stale handling).

## Conventions

- **Terraform formatting**: Always run `terraform fmt` before committing. The pre-commit hook enforces this.
- **Variable style**: Every variable in [variables.tf](variables.tf) declares `type` and `description`. Optional inputs use `default = null` (or a sensible default like `true` for `basic_auth_enabled`). Follow this pattern for any new variables.
- **Sensitive data**: Do **not** commit `*.tfvars`, `*.tfstate`, `.terraform.lock.hcl`, or `LICENSE.txt` — all are git-ignored. Auth tokens (`grafana_auth`) and secure JSON data must remain inputs, never hard-coded.
- **README updates**: `terraform_docs` runs as a pre-commit hook with `--hide providers --sort-by required`. If you add or change variables/outputs, regenerate docs rather than hand-editing the table.
- **Provider versions**: Keep `provider.tf` constraints conservative (`~>` pinning). Bump intentionally; Dependabot covers GitHub Actions only, not Terraform providers.

## Build / Validate

There is no build step. Validation steps an agent should run after edits:

```powershell
terraform fmt -recursive
terraform init -backend=false
terraform validate
tflint --init; tflint
```

Pre-commit (if installed): `pre-commit run --all-files`.

## Release Process

- Merging to `main` triggers [.github/workflows/release.yml](.github/workflows/release.yml), which runs `version-drafter-action` then `release-drafter`.
- Version bumps are driven by PR labels per [.github/version-drafter.yml](.github/version-drafter.yml) and [.github/release-drafter.yml](.github/release-drafter.yml):
  - `semver:major` → major
  - `semver:minor` or `enhancement` → minor
  - `semver:patch` or `bug` → patch (default)
- Apply the appropriate label to PRs so the draft release version is correct.

## Known Issues / Things to Watch

- [main.tf](main.tf) contains a `provider "grafana"` block. Provider configuration inside a reusable module is generally discouraged by Terraform — consumers should configure the provider themselves. Do not "fix" this without confirming with a maintainer; it is a deliberate trade-off for the current consumer pattern shown in [README.md](README.md). If asked to refactor, move the `provider` block out of [main.tf](main.tf) and remove `grafana_url` / `grafana_auth` variables, then bump as `semver:major`.
- The README example uses `url = ...` but the module variable is `ds_url`. If asked to fix the README, update the example to `ds_url = "http://influxdb.example.net:8086/"`.
- [.pre-commit-config.yaml](.pre-commit-config.yaml) pins fairly old hook revisions (e.g., `pre-commit-hooks v4.2.0`, `pre-commit-terraform v1.71.0`). Only bump when explicitly requested.

## Scope Discipline

- This module wraps **one** resource. Resist adding unrelated Grafana resources, dashboards, or alternate data source types here — those belong in sibling modules.
- Do not introduce backends, remote state, or example/test harnesses unless explicitly requested.
- Do not add docstrings, comments, or annotations to code you didn't change.
