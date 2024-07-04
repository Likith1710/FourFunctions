variable "name" {
  description = "The name for the resources"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "desired_capacity" {
  description = "The required number of instances"
  type        = number
}

variable "min_size" {
  description = "The minimum number of instances"
  type        = number
}

variable "max_size" {
  description = "The maximum number of instances"
  type        = number
}

variable "user_data" {
  description = "The user data script to configure instances"
  type        = string
}
