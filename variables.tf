variable "create_vpc" {
  description = "Controls if VPC should be created."
  type        = bool
  default     = true
}

variable "region" {
  description = "Specifies the region in which to create the VPC."
  type        = string
  default     = null
}

variable "name" {
  description = "Specifies the name of the VPC."
  type        = string
}

variable "cidr" {
  description = "Specifies the range of available subnets in the VPC."
  type        = string
}

variable "description" {
  description = "Specifies supplementary information about the VPC."
  type        = string
  default     = null
}

variable "tags" {
  description = "List of tags."
  type        = map(string)
  default     = {}
}

variable "enterprise_project_id" {
  description = "Specifies the enterprise project id of the VPC."
  type        = string
  default     = null
}