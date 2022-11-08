output "cidr" {
  description = "Specifies the range of available subnets in the VPC."
  value       = try(sbercloud_vpc.this[0].cidr, "")
}

output "enterprise_project_id" {
  description = "Specifies the enterprise project id of the VPC."
  value       = try(sbercloud_vpc.this[0].enterprise_project_id, "")
}

output "id" {
  description = "The VPC ID in UUID format."
  value       = try(sbercloud_vpc.this[0].id, "")
}

output "name" {
  description = "Specifies the name of the VPC."
  value       = try(sbercloud_vpc.this[0].name, "")
}

output "region" {
  description = "Specifies the region in which to create the VPC."
  value       = try(sbercloud_vpc.this[0].region, "")
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = sbercloud_vpc_subnet.subnet[*].id
}

output "subnet_cidr_blocks" {
  description = "List of cidrs of subnets"
  value       = compact(sbercloud_vpc_subnet.subnet[*].cidr)
}