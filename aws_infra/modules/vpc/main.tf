resource "aws_vpc" "fourjunctions" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "fourjunctions" {
  vpc_id = aws_vpc.fourjunctions.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.fourjunctions.id
  cidr_block        = cidrsubnet(aws_vpc.fourjunctions.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.fourjunctions.id
  cidr_block        = cidrsubnet(aws_vpc.fourjunctions.cidr_block, 8, count.index + var.public_subnet_count)
  map_public_ip_on_launch = false
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.name}-private-subnet-${count.index}"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "fourjunctions" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public[*].id, 0)
  tags = {
    Name = "${var.name}-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.fourjunctions.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fourjunctions.id
  }
  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.fourjunctions.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fourjunctions.id
  }
  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  count      = length(aws_subnet.public)
  subnet_id  = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count      = length(aws_subnet.private)
  subnet_id  = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

output "vpc_id" {
  value = aws_vpc.fourjunctions.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.fourjunctions.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.fourjunctions.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "nat_gateway_eip" {
  value = aws_eip.nat.public_ip
}