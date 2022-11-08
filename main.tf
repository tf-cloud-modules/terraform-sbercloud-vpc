#vpc
resource "sbercloud_vpc" "this" {
  count                 = var.create_vpc ? 1 : 0
  region                = var.region
  name                  = var.name
  cidr                  = var.cidr
  description           = var.description
  tags                  = merge(var.tags, var.vpc_tags)
  enterprise_project_id = var.enterprise_project_id
}

# subnet
resource "sbercloud_vpc_subnet" "subnet" {
  count             = var.create_vpc && length(var.subnets) > 0 ? length(var.subnets) : 0
  region            = var.region
  name              = try(var.subnet_names[count.index], format("${var.name}-subnet-%s", element(var.azs, count.index)))
  cidr              = element(concat(var.subnets.*.cidr, [""]), count.index)
  gateway_ip        = element(concat(var.subnets.*.gateway_ip, [""]), count.index)
  vpc_id            = sbercloud_vpc.this[0].id
  dhcp_enable       = var.dhcp_enable
  primary_dns       = var.primary_dns
  secondary_dns     = var.secondary_dns
  dns_list          = var.dns_list
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  tags              = merge(var.tags, var.subnet_tags)
}