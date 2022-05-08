variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
}

#VPC & Subnets
variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR to assign to the VPC	"
}

variable "nat_gateway_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT Gateways to allow servers in the private subnets to access the Internet"
  default     = false
}

variable "nat_instance_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT Instances to allow servers in the private subnets to access the Internet"
  default     = true
}