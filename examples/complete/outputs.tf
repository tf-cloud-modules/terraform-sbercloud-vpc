output "cidr" {
  description = "Specifies the range of available subnets in the VPC."
  value       = try(module.vpc.cidr, "")
}

output "enterprise_project_id" {
  description = "Specifies the enterprise project id of the VPC."
  value       = try(module.vpc.enterprise_project_id, "")
}

output "id" {
  description = "The VPC ID in UUID format."
  value       = try(module.vpc.id, "")
}

output "name" {
  description = "Specifies the name of the VPC."
  value       = try(module.vpc.name, "")
}

output "region" {
  description = "Specifies the region in which to create the VPC."
  value       = try(module.vpc.region, "")
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = try(module.vpc.subnet_ids, "")
}

output "subnet_cidr_blocks" {
  description = "List of cidrs of subnets"
  value       = try(module.vpc.subnet_cidr_blocks, "")
}