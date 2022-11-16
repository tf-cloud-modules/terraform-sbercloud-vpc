#vpc
resource "sbercloud_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  region                = var.region
  name                  = var.name
  cidr                  = var.cidr
  description           = var.description
  tags                  = merge(var.tags, var.vpc_tags)
  enterprise_project_id = var.enterprise_project_id
}

# subnet
resource "sbercloud_vpc_subnet" "subnet" {
  count = var.create_vpc && length(var.subnets) > 0 ? length(var.subnets) : 0

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

# routes for default route table
resource "sbercloud_vpc_route" "default_route" {
  for_each = { for k, v in var.default_route_table_routes : k => v }

  region         = var.region
  vpc_id         = sbercloud_vpc.this[0].id
  destination    = lookup(each.value, "destination")
  type           = lookup(each.value, "type")
  nexthop        = lookup(each.value, "nexthop")
  description    = lookup(each.value, "description", null)
  route_table_id = lookup(each.value, "route_table_id", null)
}

# public nat gateway
resource "sbercloud_nat_gateway" "this" {
  for_each = { for k, v in var.subnets : k => v
    if lookup(v, "create_nat_gateway", false)
  }

  region                = var.region
  name                  = "${sbercloud_vpc_subnet.subnet[index(var.subnets, each.value)].name}-natgw"
  subnet_id             = sbercloud_vpc_subnet.subnet[index(var.subnets, each.value)].id
  vpc_id                = sbercloud_vpc.this[0].id
  spec                  = lookup(each.value, "nat_gateway_spec")
  description           = lookup(each.value, "nat_gateway_description", null)
  enterprise_project_id = lookup(each.value, "nat_gateway_enterprise_project_id", null)
}