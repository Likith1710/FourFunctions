resource "aws_launch_template" "nginx" {
  name_prefix   = "${var.name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = element(var.private_subnet_ids, 0)
    security_groups             = [aws_security_group.nginx.id]
  }

  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "nginx" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name}-sg"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "nginx" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  launch_template {
    id      = aws_launch_template.nginx.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.private_subnet_ids

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

output "launch_template_id" {
  value = aws_launch_template.nginx.id
}

output "security_group_id" {
  value = aws_security_group.nginx.id
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.nginx.id
}
