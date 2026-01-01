data "terraform_remote_state" "org" {
  backend = "local"
  config = {
    path = "../org/terraform.tfstate"
  }
}

locals {
  account_ids = data.terraform_remote_state.org.outputs.accounts_ids


  # Create three enterprise-ish groups
  groups = {
    PlatformAdmins = "Platform team admins (security/shared services)."
    Developers     = "Developers working in dev workloads."
    Auditors       = "Read-only audit access."
  }

  # Permission sets these are AWS managed policies for simplicity
  permission_sets = {
    PlatformAdmin = {
      description      = "Admin access for platform/security operations."
      session_duration = "PT8H"
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
    PowerUserDev = {
      description      = "PowerUser access for dev workloads (no IAM admin guardrails come from SCPs)."
      session_duration = "PT8H"
      managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
    }
    ReadOnlyAudit = {
      description      = "Read-only access for auditing/visibility."
      session_duration = "PT4H"
      managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
  }
}

# Groups (Identity Store
resource "aws_identitystore_group" "groups" {
  for_each = local.groups

  identity_store_id = var.identity_store_id
  display_name      = each.key
  description       = each.value
}

# Permission sets
module "permission_sets" {
  source       = "../../modules/permission-sets"
  instance_arn = var.instance_arn

  permission_sets = local.permission_sets
}

# Assignments of groups to accounts with permission sets
# Based on the org baseline accounts
# Assign PlatformAdmins to Security account
# Assign Developers to Workloads Dev account
# Assign Auditors to both Security and Workloads Dev accounts
locals {
  assignments = [
    {
      group = "Developers"
      ps    = "PowerUserDev"
      acct  = local.account_ids["workloads_dev"]
    },
    {
      group = "PlatformAdmins"
      ps    = "PlatformAdmin"
      acct  = local.account_ids["security"]
    },
    {
      group = "Auditors"
      ps    = "ReadOnlyAudit"
      acct  = local.account_ids["security"]
    },
    {
      group = "Auditors"
      ps    = "ReadOnlyAudit"
      acct  = local.account_ids["workloads_dev"]
    },
  ]
}

resource "aws_ssoadmin_account_assignment" "assign" {
  for_each = {
    for a in local.assignments :
    "${a.group}::${a.ps}::${a.acct}" => a
  }

  instance_arn       = var.instance_arn
  permission_set_arn = module.permission_sets.permission_set_arns[each.value.ps]

  principal_id   = aws_identitystore_group.groups[each.value.group].group_id
  principal_type = "GROUP"

  target_id   = each.value.acct
  target_type = "AWS_ACCOUNT"
}
