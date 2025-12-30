resource "aws_organizations_organization" "this" {
  count = var.org_enabled ? 1 : 0

  feature_set = "ALL"
}


data "aws_organizations_organization" "this" {
  depends_on = [aws_organizations_organization.this]
}

locals {
  root_id = data.aws_organizations_organization.this.roots[0].id

  ous = toset(distinct([
    for _, account in var.accounts :
    account.ou
  ]))
}


resource "aws_organizations_organizational_unit" "ou" {
  for_each = local.ous

  name      = each.value
  parent_id = local.root_id
}


resource "aws_organizations_account" "acct" {
  for_each = var.accounts

  name  = each.value.name
  email = each.value.email

  parent_id = aws_organizations_organizational_unit.ou[each.value.ou].id

  lifecycle {
    prevent_destroy = true
  }
}



