data "terraform_remote_state" "org" {
  backend = "local"
  config = {
    path = "../org/terraform.tfstate"
  }
}

module "scp_guardrails" {
  source = "../../modules/scp-guardrails"

  workloads_ou_id = data.terraform_remote_state.org.outputs.ou_ids["Workloads"]
  root_id         = data.terraform_remote_state.org.outputs.root_id
}
