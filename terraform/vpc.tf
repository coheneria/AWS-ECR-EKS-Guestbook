resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink = false
  enable_classiclink_dns_support = false
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet-1A"
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.16.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet-1b"
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.32.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "eks-private-subnet-1a"
    "kubernetes.io/cluster/eks-cluster"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "subnet-4" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.48.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "eks-private-subnet-1b"
    "kubernetes.io/cluster/eks-cluster"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "ig-getway"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}

resource "aws_route_table_association" "public-route-association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_eip" "eip-nat" {
  vpc      = true

    tags = {
    Name = "eip-nat"
  }
}

resource "aws_nat_gateway" "eks-nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.subnet-1.id

  tags = {
    Name = "gw-NAT"
  }
}

resource "aws_route_table" "private1-route-table" {
  vpc_id       = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat.id
  }

  tags       = {
    Name     = "Private1 Route Table"
  }
}

resource "aws_route_table" "private2-route-table" {
  vpc_id       = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat.id
  }

  tags       = {
    Name     = "Private2 Route Table"
  }
}

resource "aws_route_table_association" "private1-route-association" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_route_table.private1-route-table.id
}

resource "aws_route_table_association" "private2-route-association" {
  subnet_id      = aws_subnet.subnet-4.id
  route_table_id = aws_route_table.private2-route-table.id
}