locals {
  vpc_id = var.create_vpc ? sbercloud_vpc.this[0].id : var.vpc_id
}

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
resource "sbercloud_vpc_subnet" "this" {
  count = var.create_vpc && length(var.subnets) > 0 ? length(var.subnets) : 0

  region            = var.region
  name              = try(var.subnet_names[count.index], format("${var.name}-subnet-%s", element(var.azs, count.index)))
  cidr              = element(concat(var.subnets.*.cidr, [""]), count.index)
  gateway_ip        = element(concat(var.subnets.*.gateway_ip, [""]), count.index)
  vpc_id            = local.vpc_id
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
  vpc_id         = local.vpc_id
  destination    = lookup(each.value, "destination")
  type           = lookup(each.value, "type")
  nexthop        = lookup(each.value, "nexthop")
  description    = lookup(each.value, "description", null)
  route_table_id = lookup(each.value, "route_table_id", null)
}

# public nat gateway
resource "sbercloud_nat_gateway" "this" {
  for_each = { for k, v in var.subnets : k => v
    if lookup(v, "nat_gw", null) != null
  }

  region                = var.region
  name                  = "${sbercloud_vpc_subnet.this[index(var.subnets, each.value)].name}-natgw"
  subnet_id             = sbercloud_vpc_subnet.this[index(var.subnets, each.value)].id
  vpc_id                = local.vpc_id
  spec                  = lookup(each.value.nat_gw, "spec")
  description           = "For ${sbercloud_vpc_subnet.this[index(var.subnets, each.value)].name}"
  enterprise_project_id = lookup(each.value.nat_gw, "enterprise_project_id", null)
}

# nat gateway eip 
resource "sbercloud_vpc_eip" "snat" {
  for_each = { for k, v in var.subnets : k => v
    if lookup(v, "nat_gw", null) != null && lookup(v, "eip", null) != null && lookup(v, "existing_eip", null) == null
  }

  publicip {
    type = lookup(each.value.eip, "type")
  }
  bandwidth {
    share_type  = lookup(each.value.eip, "share_type")
    name        = "${sbercloud_vpc_subnet.this[index(var.subnets, each.value)].name}-nat-gw-eip"
    size        = lookup(each.value.eip, "size")
    charge_mode = lookup(each.value.eip, "charge_mode")
  }
}

# nat gateway snat
resource "sbercloud_nat_snat_rule" "this" {
  for_each = { for k, v in var.subnets : k => v
    if lookup(v, "nat_gw", null) != null && lookup(v, "eip", null) != null || lookup(v, "existing_eip", null) != null
  }

  nat_gateway_id = sbercloud_nat_gateway.this[index(var.subnets, each.value)].id
  subnet_id      = sbercloud_vpc_subnet.this[index(var.subnets, each.value)].id
  floating_ip_id = lookup(each.value, "existing_eip", sbercloud_vpc_eip.snat[index(var.subnets, each.value)].id)
}

# subnet route table
resource "sbercloud_vpc_route_table" "subnet" {
  for_each = { for k, v in var.subnets : k => v }
  name     = "${sbercloud_vpc_subnet.this[index(var.subnets, each.value)].name}-rtb"
  vpc_id   = local.vpc_id
  subnets  = [sbercloud_vpc_subnet.this[index(var.subnets, each.value)].id]

  # ECS routes
  dynamic "route" {
    for_each = lookup(each.value, "ecs_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "ecs"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # ENI routes
  dynamic "route" {
    for_each = lookup(each.value, "eni_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "eni"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # Virtual IP routes
  dynamic "route" {
    for_each = lookup(each.value, "vip_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "vip"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # NAT routes
  dynamic "route" {
    for_each = lookup(each.value, "nat_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "nat"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # VPC Peering routes
  dynamic "route" {
    for_each = lookup(each.value, "peering", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "peering"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # VPN routes
  dynamic "route" {
    for_each = lookup(each.value, "vpn_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "vpn"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # Direct Connect routes
  dynamic "route" {
    for_each = lookup(each.value, "dc_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "dc"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # Cloud Connection routes
  dynamic "route" {
    for_each = lookup(each.value, "cc_routes", [])
    content {
      destination = lookup(route.value, "destination")
      type        = "cc"
      nexthop     = lookup(route.value, "nexthop")
      description = lookup(route.value, "description", null)
    }
  }

  # NAT Gateway Route (for nat gw created in this module)
  dynamic "route" {
    for_each = lookup(each.value, "nat_gw", [])
    content {
      destination = "0.0.0.0/0"
      type        = "nat"
      nexthop     = sbercloud_nat_gateway.this[index(var.subnets, each.value)].id
      description = "NAT Gateway SNAT"
    }
  }

  # VPC Peering Route (for vpc peering created in this module) TODO
}