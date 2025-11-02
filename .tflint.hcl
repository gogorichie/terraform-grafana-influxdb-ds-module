plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "grafana" {
  enabled = true
  version = "0.7.0"
  source  = "github.com/terraform-linters/tflint-ruleset-grafana"
}
