data "aws_availability_zones" "available" {}

# Get all VPCs with a specific tag
data "aws_vpcs" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-vpc"]
  }
}

# Create VPC only if it doesn’t exist
resource "aws_vpc" "main" {
  count = length(data.aws_vpcs.existing.ids) == 0 ? 1 : 0

  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id = aws_vpc.main[0].id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { 
    Name = "${var.cluster_name}-public-${count.index}" 
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count
  vpc_id = aws_vpc.main[0].id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + var.public_subnet_count)
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { 
    Name = "${var.cluster_name}-private-${count.index}" 
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main[0].id
  tags = { 
    Name = "${var.cluster_name}-igw" 
  }
}

resource "aws_eip" "nat" {
  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.cluster_name}-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main[0].id
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
  tags = { 
    Name = "${var.cluster_name}-public-rt" 
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main[0].id
  route { 
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id 
  }
  tags = { 
    Name = "${var.cluster_name}-private-rt" 
  }
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
