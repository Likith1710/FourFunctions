variable "name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "The number of public subnets to create"
  type        = number
}

variable "private_subnet_count" {
  description = "The number of private subnets to create"
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones in the region"
  type        = list(string)
}
