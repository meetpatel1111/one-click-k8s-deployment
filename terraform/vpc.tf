data "aws_availability_zones" "available" {}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "${var.cluster_name}-vpc" }
}

# Public subnets (for LoadBalancers, NAT)
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true # OK for public-facing services
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.cluster_name}-public-${count.index}"
  }
}

# Private subnets (for worker nodes)
resource "aws_subnet" "private" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index + var.public_subnet_count)
  map_public_ip_on_launch = false # private nodes should NOT have public IP
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.cluster_name}-private-${count.index}"
  }
}

# Internet Gateway (for public subnet)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.cluster_name}-igw" }
}

# EIP + NAT Gateway (for private subnet access to internet)
resource "aws_eip" "nat" {
  vpc  = true
  tags = { Name = "${var.cluster_name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = { Name = "${var.cluster_name}-nat-gateway" }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.cluster_name}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route table (routes via NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "${var.cluster_name}-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
