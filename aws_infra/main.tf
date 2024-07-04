provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source              = "./modules/vpc"
  name                = "ionginx-vpc"
  cidr_block          = "10.0.0.0/16"
  public_subnet_count = 3
  private_subnet_count = 3
  availability_zones  = data.aws_availability_zones.available.names
}

module "nginx" {
  source             = "./modules/nginx"
  name               = "nginx"
  ami_id             = "ami-09040d770ffe2224f"
  instance_type      = "t2.micro"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  desired_capacity   = 2
  min_size           = 2
  max_size           = 4
   user_data = base64encode(<<EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
  )
}


# Variables for Route 53 Zone ID and Record Name
variable "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
}

variable "route53_record_name" {
  description = "Name for the Route 53 A record"
  type        = string
}

# Route 53 A Record pointing to NAT Gateway
resource "aws_route53_record" "nginx_default" {
  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = "A"
  ttl     = "300"  

  records = [module.vpc.nat_gateway_eip]

  # User data for NGINX instance
  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y nginx",
      "echo 'Welcome to NGINX!' > /var/www/html/index.html",
      "systemctl start nginx",
      "systemctl enable nginx"
    ]
  }
}


output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = module.vpc.private_route_table_id
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.nginx.launch_template_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.nginx.security_group_id
}

output "autoscaling_group_id" {
  description = "The ID of the Auto Scaling group"
  value       = module.nginx.autoscaling_group_id
}
