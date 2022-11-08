resource "sbercloud_vpc" "this" {
  count                 = var.create_vpc ? 1 : 0
  region                = var.region
  name                  = var.name
  cidr                  = var.cidr
  description           = var.description
  tags                  = var.tags
  enterprise_project_id = var.enterprise_project_id
}