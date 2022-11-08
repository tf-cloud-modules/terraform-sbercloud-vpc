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
  description = "List of common tags."
  type        = map(string)
  default     = {}
}

variable "enterprise_project_id" {
  description = "Specifies the enterprise project id of the VPC."
  type        = string
  default     = null
}

variable "vpc_tags" {
  description = "List of VPC tags."
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnets inside the VPC"
  type        = list(any)
  default     = []
}

variable "dhcp_enable" {
  description = "Specifies whether the DHCP function is enabled for the subnet."
  type        = bool
  default     = false
}

variable "subnet_tags" {
  description = "List of subnet tags."
  type        = map(string)
  default     = {}
}

variable "subnet_names" {
  description = "Explicit values to use in the name values on subnets. If empty, name values are generated."
  type        = list(string)
  default     = []
}

variable "primary_dns" {
  description = "Specifies the IP address of DNS server 1 on the subnet."
  type        = string
  default     = null
}

variable "secondary_dns" {
  description = "Specifies the IP address of DNS server 2 on the subnet."
  type        = string
  default     = null
}

variable "dns_list" {
  description = "Specifies the DNS server address list of a subnet."
  type        = list(string)
  default     = null
}